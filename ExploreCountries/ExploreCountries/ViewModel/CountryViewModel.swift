// CountryViewModel.swift
import UIKit

class CountryViewModel {
    // MARK: - Properties

    // Injected network manager
    private let networkManager: NetworkManagerProtocol

    // Public properties
    var countries: [Country] = [] {
        didSet {
            onCountriesUpdated?()
        }
    }

    var onCountriesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStatusChanged: ((Bool) -> Void)?

    var currentFilter: PopulationFilter = .all {
        didSet {
            applyFilterAndSearch()
        }
    }

    var searchText: String = "" {
        didSet {
            applyFilterAndSearch()
        }
    }

    // Private properties
    var allCountries: [Country] = []
    private var isLoading: Bool = false {
        didSet {
            onLoadingStatusChanged?(isLoading)
        }
    }
    private var retryCount = 0
    private let maxRetryAttempts = 3

    // MARK: - Initializer

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - Methods

    func fetchCountries() {
        isLoading = true

        guard let url = URL(string: URLConstants.countriesURL) else {
            isLoading = false
            onError?("Invalid URL.")
            return
        }

        networkManager.fetchCountries(countriesURL: url) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let fetchedCountries):
                self.retryCount = 0 // Reset retry count on success
                self.allCountries = fetchedCountries
                self.applyFilterAndSearch()
            case .failure(let error):
                if self.retryCount < self.maxRetryAttempts {
                    self.retryCount += 1
                    self.fetchCountries() // Retry fetching
                } else {
                    self.onError?(self.errorMessage(for: error))
                }
            }
        }
    }

    func applyFilterAndSearch() {
        var filteredCountries = allCountries

        // Apply population filter
        filteredCountries = filteredCountries.filter { country in
            switch currentFilter {
            case .lessThan1M:
                return (country.population ?? 0) < 1_000_000
            case .lessThan5M:
                return (country.population ?? 0) < 5_000_000
            case .lessThan10M:
                return (country.population ?? 0) < 10_000_000
            case .all:
                return true
            }
        }

        // Apply search text filter
        if !searchText.isEmpty {
            filteredCountries = filteredCountries.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }

        countries = filteredCountries
    }

    // MARK: - Private Methods

    private func errorMessage(for error: NetworkError) -> String {
        switch error {
        case .invalidResponse:
            return "Invalid response from the server."
        case .noData:
            return "No data received from the server."
        case .decodingError:
            return "Failed to decode data."
        case .networkError(let underlyingError):
            return underlyingError.localizedDescription
        case .invalidURL:
            return "Invalid URL."
        }
    }
}

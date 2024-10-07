//
//  CountryViewModel.swift
//  ExploreCountries
//
//  Created by Shaunak Jagtap on 07/10/24.
//

import UIKit

class CountryViewModel {
    var countries: [Country] = [] {
            didSet {
                onCountriesUpdated?()
            }
        }
        private var allCountries: [Country] = []
        var onCountriesUpdated: (() -> Void)?
    
    func fetchCountries() {
        NetworkManager.shared.fetchCountries(countriesURL: URL(string: URLConstants.countriesURL), completion: { [weak self] result in
            switch result {
            case .success(let fetchedCountries):
                self?.allCountries = fetchedCountries
                self?.countries = fetchedCountries
            case .failure(let error):
                print("Error fetching countries: \(error)")
            }
        })
    }
    
    func filterCountries(by searchText: String) {
        if searchText.isEmpty {
            countries = allCountries
        } else {
            countries = allCountries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

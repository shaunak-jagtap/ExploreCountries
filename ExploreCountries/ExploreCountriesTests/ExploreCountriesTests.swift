//
//  CountryViewModelTests.swift
//  ExploreCountriesTests
//
//  Created by Shaunak Jagtap on 07/10/24.
//

import XCTest
@testable import ExploreCountries

class CountryViewModelTests: XCTestCase {

    var viewModel: CountryViewModel!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = CountryViewModel(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testFetchCountriesSuccess() {
        // Given
        let expectation = self.expectation(description: "Countries fetched")
        let mockCountries = [
            Country(
                abbreviation: "CA",
                capital: "Capital A",
                currency: "Currency A",
                name: "Country A",
                phone: "+1",
                population: 500_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 1
            ),
            Country(
                abbreviation: "CB",
                capital: "Capital B",
                currency: "Currency B",
                name: "Country B",
                phone: "+2",
                population: 2_000_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 2
            )
        ]
        mockNetworkManager.countriesToReturn = mockCountries

        viewModel.onCountriesUpdated = {
            expectation.fulfill()
        }

        // When
        viewModel.fetchCountries()

        // Then
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertEqual(self.viewModel.countries.count, 2)
            XCTAssertEqual(self.viewModel.countries[0].name, "Country A")
            XCTAssertEqual(self.viewModel.countries[1].name, "Country B")
            XCTAssertEqual(self.mockNetworkManager.fetchCallCount, 1)
        }
    }

    func testFetchCountriesFailureWithRetry() {
        // Given
        let expectation = self.expectation(description: "Error received after retries")
        mockNetworkManager.shouldReturnError = true
        mockNetworkManager.errorToReturn = .noData
        var errorMessage: String?

        viewModel.onError = { error in
            errorMessage = error
            expectation.fulfill()
        }

        // When
        viewModel.fetchCountries()

        // Then
        waitForExpectations(timeout: 2.0) { _ in
            XCTAssertEqual(self.mockNetworkManager.fetchCallCount, 3) // Should retry 3 times
            XCTAssertEqual(errorMessage, "No data received from the server.")
        }
    }

    func testApplyFilterLessThan1M() {
        // Given
        let mockCountries = [
            Country(
                abbreviation: "CA",
                capital: "Capital A",
                currency: "Currency A",
                name: "Country A",
                phone: "+1",
                population: 500_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 1
            ),
            Country(
                abbreviation: "CB",
                capital: "Capital B",
                currency: "Currency B",
                name: "Country B",
                phone: "+2",
                population: 2_000_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 2
            )
        ]
        viewModel.allCountries = mockCountries

        // When
        viewModel.currentFilter = .lessThan1M

        // Then
        XCTAssertEqual(viewModel.countries.count, 1)
        XCTAssertEqual(viewModel.countries[0].name, "Country A")
    }

    func testApplyFilterLessThan5M() {
        // Given
        let mockCountries = [
            Country(
                abbreviation: "CA",
                capital: "Capital A",
                currency: "Currency A",
                name: "Country A",
                phone: "+1",
                population: 500_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 1
            ),
            Country(
                abbreviation: "CB",
                capital: "Capital B",
                currency: "Currency B",
                name: "Country B",
                phone: "+2",
                population: 4_000_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 2
            ),
            Country(
                abbreviation: "CC",
                capital: "Capital C",
                currency: "Currency C",
                name: "Country C",
                phone: "+3",
                population: 6_000_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 3
            )
        ]
        viewModel.allCountries = mockCountries

        // When
        viewModel.currentFilter = .lessThan5M

        // Then
        XCTAssertEqual(viewModel.countries.count, 2)
        XCTAssertEqual(viewModel.countries[0].name, "Country A")
        XCTAssertEqual(viewModel.countries[1].name, "Country B")
    }

    func testSearchTextFiltering() {
        // Given
        let mockCountries = [
            Country(
                abbreviation: "AR",
                capital: "Buenos Aires",
                currency: "ARS",
                name: "Argentina",
                phone: "+54",
                population: 44_000_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 1
            ),
            Country(
                abbreviation: "AU",
                capital: "Canberra",
                currency: "AUD",
                name: "Australia",
                phone: "+61",
                population: 25_000_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 2
            ),
            Country(
                abbreviation: "AT",
                capital: "Vienna",
                currency: "EUR",
                name: "Austria",
                phone: "+43",
                population: 8_000_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 3
            )
        ]
        viewModel.allCountries = mockCountries

        // When
        viewModel.searchText = "aus"

        // Then
        XCTAssertEqual(viewModel.countries.count, 2)
        XCTAssertEqual(viewModel.countries[0].name, "Australia")
        XCTAssertEqual(viewModel.countries[1].name, "Austria")
    }

    func testCombinedFilterAndSearch() {
        // Given
        let mockCountries = [
            Country(
                abbreviation: "CA",
                capital: "Capital A",
                currency: "Currency A",
                name: "Country A",
                phone: "+1",
                population: 500_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 1
            ),
            Country(
                abbreviation: "CB",
                capital: "Capital B",
                currency: "Currency B",
                name: "Country B",
                phone: "+2",
                population: 2_000_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 2
            ),
            Country(
                abbreviation: "CC",
                capital: "Capital C",
                currency: "Currency C",
                name: "Country C",
                phone: "+3",
                population: 6_000_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 3
            ),
            Country(
                abbreviation: "CD",
                capital: "Capital D",
                currency: "Currency D",
                name: "Country D",
                phone: "+4",
                population: 8_000_000,
                media: CountryMedia(flag: "", emblem: "", orthographic: ""),
                id: 4
            )
        ]
        viewModel.allCountries = mockCountries

        // When
        viewModel.currentFilter = .lessThan10M
        viewModel.searchText = "country d"

        // Then
        XCTAssertEqual(viewModel.countries.count, 1)
        XCTAssertEqual(viewModel.countries[0].name, "Country D")
    }
}


@testable import ExploreCountries
class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var errorToReturn: NetworkError = .noData
    var countriesToReturn: [Country] = []
    var fetchCallCount = 0

    func fetchCountries(countriesURL: URL, completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        fetchCallCount += 1
        if shouldReturnError {
            completion(.failure(errorToReturn))
        } else {
            completion(.success(countriesToReturn))
        }
    }
}

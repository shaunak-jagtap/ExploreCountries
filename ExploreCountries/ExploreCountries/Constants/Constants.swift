//
//  Constants.swift
//  ExploreCountries
//
//  Created by Shaunak Jagtap on 07/10/24.
//

import UIKit

struct UIConstants {
    // Heights and Dimensions
    static let searchBarHeight: CGFloat = 44.0
    static let filterButtonWidth: CGFloat = 60.0
    static let filterButtonHeight: CGFloat = 44.0
    static let resultCountLabelHeight: CGFloat = 20.0
    static let elementSpacing: CGFloat = 8.0
    static let leadingTrailingMargin: CGFloat = 16.0

    // Fonts
    static let filterButtonFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let resultCountLabelFont = UIFont.systemFont(ofSize: 14)
    static let errorLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)

    // Colors
    static let resultCountLabelTextColor = UIColor.gray
    static let errorLabelTextColor = UIColor.systemRed

    // Strings
    static let searchBarPlaceholder = NSLocalizedString("Search by Country", comment: "Placeholder text in the search bar")
    static let navigationTitle = NSLocalizedString("Countries", comment: "Title of the main screen")
    static let filterByPopulationTitle = NSLocalizedString("Filter by Population", comment: "Filter options title")
    static let cancelActionTitle = NSLocalizedString("Cancel", comment: "Cancel action")
    static let retryButtonTitle = NSLocalizedString("Retry", comment: "Retry button title")
}

struct AccessibilityLabels {
    static let searchBar = NSLocalizedString("Country Search Bar", comment: "Search bar for entering country names")
    static let filterButton = NSLocalizedString("Filter Button", comment: "Button to open population filter options")
}

struct CellConstants {
    static let cellHeight: CGFloat = 100.0
}

struct URLConstants {
    static let countriesURL = "https://api.sampleapis.com/countries/countries"
}

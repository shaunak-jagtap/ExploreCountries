//
//  Country.swift
//  ExploreCountries
//
//  Created by Shaunak Jagtap on 07/10/24.
//

import UIKit

struct Country: Codable {
    let abbreviation: String
    let capital: String
    let currency: String
    let name: String
    let phone: String
    let population: Int?
    let media: CountryMedia
    let id: Int
}

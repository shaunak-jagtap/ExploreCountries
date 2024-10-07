//
//  NetworkManager.swift
//  ExploreCountries
//
//  Created by Shaunak Jagtap on 07/10/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchCountries(countriesURL: URL?, completion: @escaping (Result<[Country], Error>) -> Void) {
        guard let url = countriesURL else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                completion(.success(countries))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}

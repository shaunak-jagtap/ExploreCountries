//
//  NetworkManager.swift
//  ExploreCountries
//
//  Created by Shaunak Jagtap on 07/10/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchCountries(countriesURL: URL, completion: @escaping (Result<[Country], NetworkError>) -> Void)
}


enum NetworkError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case noData
    case decodingError
    case networkError(underlyingError: Error)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCountries(countriesURL: URL, completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: countriesURL) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(underlyingError: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse(statusCode: -1)))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                completion(.success(countries))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}

//
//  APIService.swift
//  MyCuisineData
//
//  Created by sokolli on 10/19/24.
//

import Foundation

/// A singleton service class responsible for fetching recipe data from a remote URL.
/// Implements `APIServiceProtocol` to provide a standardized method for data retrieval, handling network errors,
/// and decoding JSON data. Returns either successfully decoded data (`RecipesData`) or an appropriate error (`APIServiceError`).
///
/// Components:
/// - `APIServiceError`: Enum defining possible error cases such as malformed or empty data.
/// - `fetchData`: Fetches data asynchronously, decoding it into `RecipesData`, or returns an error.

enum APIServiceError: Error {
    case malformedData
    case emptyData
}

protocol APIServiceProtocol {
    func fetchData(completion: @escaping (Result<RecipesData, APIServiceError>) -> Void)
}

class APIService: APIServiceProtocol {
    static let shared = APIService()
    var session: URLSessionProtocol = URLSession.shared

    func fetchData(completion: @escaping (Result<RecipesData, APIServiceError>) -> Void) {
        guard let url = URL(string: Constants.dataUrl) else {
            completion(.failure(.malformedData))
            return
        }

        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.malformedData))
                return
            }

            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }

            do {
                let results = try JSONDecoder().decode(RecipesData.self, from: data)
                if results.recipes.isEmpty {
                    completion(.failure(.emptyData))
                } else {
                    completion(.success(results))
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(.malformedData))
            }
        }
        task.resume()
    }
}

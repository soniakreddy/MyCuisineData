//
//  MockAPIService.swift
//  MyCuisineData
//
//  Created by sokolli on 10/29/24.
//

import Testing
@testable import MyCuisineData
import XCTest

/// `MockAPIService` is a mock implementation of the `APIService` used for testing purposes.
/// It allows for the simulation of different API responses, such as returning empty or malformed
/// data, or providing predefined mock recipes. This enables controlled testing of components
/// dependent on the API service without actual network calls.

class MockAPIService: APIService {
    var shouldReturnEmptyData = false
    var shouldReturnMalformedData = false

    override func fetchData(completion: @escaping (Result<RecipesData, APIServiceError>) -> Void) {
        if shouldReturnEmptyData {
            completion(.failure(.emptyData))
        } else if shouldReturnMalformedData {
            completion(.failure(.malformedData))
        } else {
            let mockRecipes = [
                Recipe(cuisine: "Malaysian", name: "Apam Balik",
                       photoUrlLarge: "https://example.com/large.jpg",
                       photoUrlSmall: "https://example.com/small.jpg",
                       uuid: "mock-uuid-1",
                       sourceUrl: "https://example.com/recipe1",
                       youtubeUrl: "https://youtube.com/1"),
                Recipe(cuisine: "British", name: "Apple & Blackberry Crumble",
                       photoUrlLarge: nil,
                       photoUrlSmall: "https://example.com/small2.jpg",
                       uuid: "mock-uuid-2",
                       sourceUrl: nil,
                       youtubeUrl: "https://youtube.com/2")
            ]
            let mockRecipesData = RecipesData(recipes: mockRecipes)
            completion(.success(mockRecipesData))
        }
    }
}

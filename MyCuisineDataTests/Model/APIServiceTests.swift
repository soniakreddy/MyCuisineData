//
//  APIServiceTests.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//

import Testing
@testable import MyCuisineData
import XCTest

/// `APIServiceTests` is a unit test class for testing the `APIService` functionality.
/// It includes tests for successful data fetching, handling of malformed data, and
/// scenarios where the data is empty. Each test uses a `FakeURLSession` to simulate
/// network responses without making actual API calls.

class APIServiceTests: XCTestCase {
    func testFetchDataSuccess() {
        let jsonData = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg",
                    "source_url": "https://example.com/recipe1",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://youtube.com/1"
                },
                {
                    "cuisine": "British",
                    "name": "Apple & Blackberry Crumble",
                    "photo_url_large": "https://example.com/large2.jpg",
                    "photo_url_small": "https://example.com/small2.jpg",
                    "source_url": "https://example.com/recipe2",
                    "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    "youtube_url": "https://youtube.com/2"
                }
            ]
        }
        """.data(using: .utf8)!

        let urlSession = FakeURLSession(data: jsonData, response: nil, error: nil)
        let apiService = APIService()
        apiService.session = urlSession

        let expectation = self.expectation(description: "Completion handler invoked")

        apiService.fetchData { result in
            switch result {
                case .success(let recipesData):
                    XCTAssertEqual(recipesData.recipes.count, 2)
                    XCTAssertEqual(recipesData.recipes[0].name, "Apam Balik")
                    XCTAssertEqual(recipesData.recipes[1].name, "Apple & Blackberry Crumble")
                case .failure(let error):
                    XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchDataMalformedData() {
        let jsonData = """
        {
            "malformedKey": "malformedValue"
        }
        """.data(using: .utf8)!

        let urlSession = FakeURLSession(data: jsonData, response: nil, error: nil)
        let apiService = APIService()
        apiService.session = urlSession

        let expectation = self.expectation(description: "Completion handler invoked")

        apiService.fetchData { result in
            switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertEqual(error, APIServiceError.malformedData, "Expected error for malformed data")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchDataEmptyData() {
        let jsonData = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!

        let urlSession = FakeURLSession(data: jsonData, response: nil, error: nil)
        let apiService = APIService()
        apiService.session = urlSession

        let expectation = self.expectation(description: "Completion handler invoked")

        apiService.fetchData { result in
            switch result {
                case .success(let recipesData):
                    XCTAssertEqual(recipesData.recipes.count, 0, "Expected no recipes but got some")
                case .failure(let error):
                    XCTAssertEqual(error, APIServiceError.emptyData, "Expected error for empty data")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}

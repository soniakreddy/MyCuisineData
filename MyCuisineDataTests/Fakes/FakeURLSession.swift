//
//  FakeURLSession.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//

import Testing
@testable import MyCuisineData
import XCTest

/// `FakeURLSession` is a mock implementation of the `URLSessionProtocol` used for testing.
/// It simulates network responses by providing predefined mock data, responses, and errors
/// when the `dataTask` method is called, enabling controlled testing of networking logic without
/// actual network calls.

class FakeURLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
        completionHandler(mockData, mockResponse, mockError)
        return URLSessionDataTask()
    }
    
    private let mockData: Data?
    private let mockResponse: URLResponse?
    private let mockError: Error?

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
    }
}

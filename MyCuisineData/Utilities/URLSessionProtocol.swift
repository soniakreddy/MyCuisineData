//
//  URLSessionProtocol.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//

import Foundation

/// `URLSessionProtocol` defines a protocol for creating data tasks with a URL request.
/// It abstracts the functionality of `URLSession` to allow for easier mocking and testing.
/// The extension of `URLSession` conforms to this protocol, enabling the use of `URLSession`
/// methods while adhering to the protocol's defined interface.

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

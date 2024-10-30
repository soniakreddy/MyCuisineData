//
//  BaseViewControllerTests.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//

import Testing
@testable import MyCuisineData
import XCTest

/// `BaseViewControllerTests` is a unit test suite for the `BaseViewController` class,
/// focusing on validating the properties of the gradient layer applied to the view.
/// The tests ensure that the gradient colors, locations, start point, and end point
/// are set correctly upon loading the view.

class BaseViewControllerTests: XCTestCase {
    var viewController: BaseViewController!

    override func setUp() {
        super.setUp()
        viewController = BaseViewController()
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    func testGradientLayerProperties() {
        guard let gradientLayer = viewController.view.layer.sublayers?.first as? CAGradientLayer else { return }
        XCTAssertEqual(gradientLayer.colors as? [CGColor], Constants.gradientColors, "The gradient colors should match the expected colors.")
        XCTAssertEqual(gradientLayer.locations, [0.0, 0.5, 1.0], "The gradient locations should match the expected locations.")
        XCTAssertEqual(gradientLayer.startPoint, CGPoint(x: 0.0, y: 0.0), "The gradient start point should be (0.0, 0.0).")
        XCTAssertEqual(gradientLayer.endPoint, CGPoint(x: 1.0, y: 1.0), "The gradient end point should be (1.0, 1.0).")
    }
}

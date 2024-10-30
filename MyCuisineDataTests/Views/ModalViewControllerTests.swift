    //
    //  ModalViewControllerTests.swift
    //  MyCuisineData
    //
    //  Created by sokolli on 10/28/24.
    //

import Testing
@testable import MyCuisineData
import XCTest
import WebKit

/// `ModalViewControllerTests` is a unit test suite for the `ModalViewController` class,
/// focusing on verifying the functionality of the web view loading,
/// close button action, and activity indicator visibility.
/// The tests ensure that the correct URL is loaded,
/// the activity indicator behaves as expected during web navigation,
/// and the close button triggers the appropriate dismiss behavior.

class ModalViewControllerTests: XCTestCase {
    var modalViewController: ModalViewController!

    override func setUp() {
        super.setUp()

        modalViewController = ModalViewController(urlString: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
        modalViewController.loadViewIfNeeded()
    }

        override func tearDown() {
            modalViewController = nil
            super.tearDown()
        }

        func testWebViewLoading() {
            XCTAssertEqual(modalViewController.urlString, "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
            XCTAssertNotNil(webView)
            XCTAssertTrue(webView.isLoading)
        }

        func testCloseButtonTapped() {
            closeButton.sendActions(for: .touchUpInside)
            XCTAssertFalse(modalViewController.isBeingDismissed)
        }

        func testActivityIndicatorVisibility() {
            XCTAssertFalse(modalViewController.activityIndicator.isAnimating)

            modalViewController.webView(modalViewController.webView, didStartProvisionalNavigation: nil)
            XCTAssertTrue(modalViewController.activityIndicator.isAnimating)

            modalViewController.webView(modalViewController.webView, didFinish: nil)
            XCTAssertFalse(modalViewController.activityIndicator.isAnimating)
        }


    }

extension ModalViewControllerTests {
    var activityIndicator: UIActivityIndicatorView! {
        return modalViewController.view.viewWithAccessibilityIdentifier(Constants.activityIndicator, classType: UIActivityIndicatorView.self)!
    }
    var webView: WKWebView! {
        return modalViewController.view.viewWithAccessibilityIdentifier(Constants.webView, classType: WKWebView.self)!
    }
    var closeButton: UIButton! {
        return modalViewController.view.viewWithAccessibilityIdentifier(Constants.closeButton, classType: UIButton.self)!
    }
}

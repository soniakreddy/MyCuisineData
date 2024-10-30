//
//  RecipeViewModelTests 2.swift
//  MyCuisineData
//
//  Created by sokolli on 10/29/24.
//

import Testing
@testable import MyCuisineData
import XCTest

/// `RecipeViewModelTests` is a unit test suite for the `RecipeViewModel` class,
/// utilizing a mock API service and a fake delegate to verify the correct
/// behavior of recipe loading, error handling, and filtering functionalities.
/// The tests include scenarios for successful data loading, handling
/// empty and malformed data, and filtering recipes based on search criteria.

class RecipeViewModelTests: XCTestCase {
    var viewModel: RecipeViewModel!
    var delegate: FakeRecipeViewModelDelegate!
    var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = RecipeViewModel(apiService: mockAPIService)
        delegate = FakeRecipeViewModelDelegate()
        viewModel.delegate = delegate
    }

    override func tearDown() {
        viewModel = nil
        delegate = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testLoadRecipesSuccess() {
        viewModel.loadRecipes()

        XCTAssertTrue(delegate.didLoadRecipesCalled)
        XCTAssertEqual(viewModel.numberOfRecipes, 2)
        XCTAssertEqual(viewModel.recipe(at: 0).name, "Apam Balik")
        XCTAssertEqual(viewModel.recipe(at: 1).photoUrlSmall, "https://example.com/small2.jpg")
    }

    func testLoadRecipesEmptyDataFailure() {
        mockAPIService.shouldReturnEmptyData = true
        viewModel.loadRecipes()

        XCTAssertTrue(delegate.didFailToLoadRecipesCalled)
        XCTAssertEqual(delegate.errorReceived, APIServiceError.emptyData)
        XCTAssertEqual(viewModel.numberOfRecipes, 0)
    }

    func testLoadRecipesMalformedDataFailure() {
        mockAPIService.shouldReturnMalformedData = true
        viewModel.loadRecipes()

        XCTAssertTrue(delegate.didFailToLoadRecipesCalled)
        XCTAssertEqual(delegate.errorReceived, APIServiceError.malformedData)
    }

    func testFilterRecipesWithSearchText() {
        viewModel.loadRecipes()
        viewModel.filterRecipes(with: "Malaysian")

        XCTAssertTrue(delegate.didUpdateFilteredRecipesCalled)
        XCTAssertEqual(viewModel.numberOfRecipes, 1)
        XCTAssertEqual(viewModel.recipe(at: 0).name, "Apam Balik")
    }

    func testFilterRecipesWithEmptySearchText() {
        viewModel.loadRecipes()

        viewModel.filterRecipes(with: "")

        XCTAssertTrue(delegate.didUpdateFilteredRecipesCalled)
        XCTAssertEqual(viewModel.numberOfRecipes, 2)
    }

    func testRecipeAccessors() {
        viewModel.loadRecipes()

        XCTAssertEqual(viewModel.numberOfRecipes, 2)
        XCTAssertEqual(viewModel.recipe(at: 1).name, "Apple & Blackberry Crumble")
        XCTAssertNotNil(viewModel.recipe(at: 1).youtubeUrl)
    }
}

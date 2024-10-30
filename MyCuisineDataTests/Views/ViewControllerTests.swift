//
//  ViewControllerTests.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//

import Testing
@testable import MyCuisineData
import XCTest

/// Unit tests for the `ViewController` class, validating its behavior with the `RecipeViewModel`.
/// Tests cover loading recipes, filtering based on search criteria, navigation to recipe details,
/// and handling errors for malformed and empty data URLs. Ensures proper configuration of the
/// navigation bar and refresh control interactions.

final class ViewControllerTests: XCTestCase {
    private var viewController: ViewController!
    private var navigationController: UINavigationController!
    private var recipeViewModel: FakeRecipeViewModel!
    private var delegate: FakeRecipeViewModelDelegate!

    override func setUp() {
        super.setUp()
        viewController = ViewController()
        navigationController = UINavigationController(rootViewController: viewController)
        recipeViewModel = FakeRecipeViewModel()
        delegate = FakeRecipeViewModelDelegate()
        viewController.loadViewIfNeeded()
        recipeViewModel.delegate = delegate
        viewController.viewModel = recipeViewModel
    }

    override func tearDown() {
        navigationController = nil
        recipeViewModel = nil
        delegate = nil
        super.tearDown()
    }

    func setupFakeData() {
        let recipe1 = Recipe(cuisine: "Malaysian",
                             name: "Apam Balik",
                             photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                             photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                             uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                             sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                             youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")

        let recipe2 = Recipe(cuisine: "British",
                             name: "Apple & Blackberry Crumble",
                             photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                             photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                             uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
                             sourceUrl: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                             youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4")

        let recipe3 = Recipe(cuisine: "British",
                             name: "Apple Frangipan Tart",
                             photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
                             photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg",
                             uuid: "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
                             sourceUrl: "https://www.youtube.com/watch?v=rp8Slv4INLk",
                             youtubeUrl: nil)

        let recipe4 = Recipe(cuisine: "British",
                             name: "Bakewell Tart",
                             photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/large.jpg",
                             photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/small.jpg",
                             uuid: "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
                             sourceUrl: "https://www.youtube.com/watch?v=1ahpSTf_Pvk",
                             youtubeUrl: nil)
        recipeViewModel.fakeRecipes = [recipe1, recipe2, recipe3, recipe4]
    }

    func testRecipeViewModel() {
        setupFakeData()
        XCTAssertFalse(delegate.didLoadRecipesCalled)
        XCTAssertFalse(delegate.didUpdateFilteredRecipesCalled)

        recipeViewModel.delegate = delegate
        viewController.viewModel = recipeViewModel
        recipeViewModel.loadRecipes()

        XCTAssertTrue(delegate.didLoadRecipesCalled)
        XCTAssertEqual(recipeViewModel.numberOfRecipes, 4)

        recipeViewModel.filterRecipes(with: "Apple")
        XCTAssertTrue(delegate.didUpdateFilteredRecipesCalled)

        XCTAssertEqual(recipeViewModel.numberOfRecipes, 2)
        XCTAssertEqual(recipeViewModel.recipe(at: 0).name, "Apple & Blackberry Crumble")

        recipeViewModel.filterRecipes(with: "British")
        XCTAssertTrue(delegate.didUpdateFilteredRecipesCalled)

        XCTAssertEqual(recipeViewModel.numberOfRecipes, 3)
        XCTAssertEqual(recipeViewModel.recipe(at: 0).cuisine, "British")

        recipeViewModel.filterRecipes(with: "")
        XCTAssertTrue(delegate.didUpdateFilteredRecipesCalled)
        XCTAssertEqual(recipeViewModel.numberOfRecipes, 4)

        recipeViewModel.filterRecipes(with: "nxmnx")
        XCTAssertTrue(delegate.didUpdateFilteredRecipesCalled)
        XCTAssertEqual(recipeViewModel.numberOfRecipes, 0)
    }

    func testNavigationBarTitle() {
        XCTAssertEqual(viewController.title, Constants.titleText)
        XCTAssertNotNil(viewController.navigationItem.searchController)
        XCTAssertTrue(viewController.navigationItem.hidesSearchBarWhenScrolling)

        guard let navigationController = viewController.navigationController else { return }
        XCTAssertTrue(navigationController.navigationBar.prefersLargeTitles)
        XCTAssertFalse(navigationController.isNavigationBarHidden)
        XCTAssertEqual(navigationController.navigationBar.titleTextAttributes as! [NSAttributedString.Key : UIColor], [NSAttributedString.Key.foregroundColor:  Constants.darkPurpleColor])
    }

    func testDidSelectRowPushesRecipeDetailsViewController() {
        setupFakeData()
        recipeViewModel.loadRecipes()
        let indexPath = IndexPath(row: 0, section: 0)
        viewController.tableView(tableView, didSelectRowAt: indexPath)

        XCTAssertTrue(viewController.navigationController?.topViewController is RecipeDetailsViewController)
        let recipeDetailsVC = viewController.navigationController?.topViewController as! RecipeDetailsViewController
        XCTAssertEqual(recipeDetailsVC.recipe?.name, "Apam Balik")
        XCTAssertEqual(recipeDetailsVC.recipe?.cuisine, "Malaysian")
    }

    func testRefreshControlActionCallsLoadRecipes() {
        viewController.onRefresh()
        XCTAssertTrue(delegate.didLoadRecipesCalled)
    }

    func testSearchUpdatesFilteredRecipes() {
        setupFakeData()
        recipeViewModel.loadRecipes()
        let searchController = UISearchController()
        searchController.searchBar.text = ""
        viewController.updateSearchResults(for: searchController)

        XCTAssertTrue(delegate.didUpdateFilteredRecipesCalled)
        XCTAssertEqual(viewController.viewModel.numberOfRecipes, 4)

        searchController.searchBar.text = "wrong text"
        viewController.updateSearchResults(for: searchController)
    }

    func testSearchWithWrongText() {
        setupFakeData()
        recipeViewModel.loadRecipes()
        let searchController = UISearchController()
        searchController.searchBar.text = "wrong text"
        viewController.updateSearchResults(for: searchController)

        XCTAssertTrue(delegate.didUpdateFilteredRecipesCalled)
        XCTAssertEqual(viewController.viewModel.numberOfRecipes, 0)
    }

    func testSearchWithNameText() {
        setupFakeData()
        recipeViewModel.loadRecipes()
        let searchController = UISearchController()
        searchController.searchBar.text = "Apple"
        viewController.updateSearchResults(for: searchController)

        XCTAssertTrue(delegate.didUpdateFilteredRecipesCalled)
        XCTAssertEqual(viewController.viewModel.numberOfRecipes, 2)
    }

    func testSearchWithCuisineText() {
        setupFakeData()
        recipeViewModel.loadRecipes()
        let searchController = UISearchController()
        searchController.searchBar.text = "British"
        viewController.updateSearchResults(for: searchController)

        XCTAssertTrue(delegate.didUpdateFilteredRecipesCalled)
        XCTAssertEqual(viewController.viewModel.numberOfRecipes, 3)
    }

    func testViewWithMalformedURL() {
        recipeViewModel.error = .malformedData
        recipeViewModel.loadRecipes()

        XCTAssertTrue(delegate.didFailToLoadRecipesCalled)
        XCTAssertEqual(recipeViewModel.error, .malformedData)
    }

    func testViewWithEmptyDataURL() {
        recipeViewModel.error = .emptyData
        recipeViewModel.loadRecipes()

        XCTAssertTrue(delegate.didFailToLoadRecipesCalled)
        XCTAssertEqual(recipeViewModel.error, .emptyData)
    }
}

extension ViewControllerTests {
    var refreshControl: UIRefreshControl! {
        return viewController.view.viewWithAccessibilityIdentifier(Constants.refreshControl, classType: UIRefreshControl.self)!
    }

    var tableView: UITableView! {
        return viewController.view.viewWithAccessibilityIdentifier(Constants.tableView, classType: UITableView.self)!
    }
}

//
//  RecipeDetailsViewControllerTests.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//

import Testing
@testable import MyCuisineData
import XCTest

/// `RecipeDetailsViewControllerTests` is a unit test suite for the `RecipeDetailsViewController` class,
/// aimed at validating the configuration of the view with various recipe data states,
/// including handling valid, missing, and invalid image URLs.
/// The tests also check the functionality of buttons to present additional views for viewing the recipe
/// and watching related videos.

class RecipeDetailsViewControllerTests: XCTestCase {
    var recipeDetailsViewController: RecipeDetailsViewController!
    var recipe: Recipe!

    override func setUp() {
        super.setUp()
        recipe = Recipe(cuisine: "Malaysian",
                        name: "Apam Balik",
                        photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                        photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                        sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                        youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        recipeDetailsViewController = RecipeDetailsViewController(recipe: recipe)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = recipeDetailsViewController
        window.makeKeyAndVisible()
        recipeDetailsViewController.loadViewIfNeeded()
    }

    override func tearDown() {
        recipeDetailsViewController = nil
        recipe = nil
        super.tearDown()
    }

    func testViewConfigurationWithImageUrl() {
        recipeDetailsViewController.configureView()

        XCTAssertEqual(cuisineLabel.text, recipe.cuisine)
        XCTAssertEqual(nameLabel.text, recipe.name)
        XCTAssertNotNil(foodImageView.image)
    }

    func testViewConfigurationWithNoImageUrl() {
        recipeDetailsViewController.configureView()
        recipe = Recipe(cuisine: "Malaysian",
                        name: "Apam Balik",
                        photoUrlLarge: nil,
                        photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                        sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                        youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        XCTAssertEqual(cuisineLabel.text, recipe.cuisine)
        XCTAssertEqual(nameLabel.text, recipe.name)
        XCTAssertEqual(foodImageView.image, Constants.placeholderImage)
    }

    func testViewConfigurationWithInvalidImageUrl() {
        recipeDetailsViewController.configureView()
        recipe = Recipe(cuisine: "Malaysian",
                        name: "Apam Balik",
                        photoUrlLarge: nil,
                        photoUrlSmall: "invalid url",
                        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                        sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                        youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        XCTAssertEqual(cuisineLabel.text, recipe.cuisine)
        XCTAssertEqual(nameLabel.text, recipe.name)
        XCTAssertEqual(foodImageView.image, Constants.placeholderImage)
    }

    func testViewRecipeButtonPressed() {
        viewRecipeButton.sendActions(for: .touchUpInside)
        let presentedViewController = recipeDetailsViewController.presentedViewController as? ModalViewController
        XCTAssertNotNil(presentedViewController)
    }

    func testWatchVideoButtonPressed() {
        watchVideoButton.sendActions(for: .touchUpInside)
        let presentedViewController = recipeDetailsViewController.presentedViewController as? ModalViewController
        XCTAssertNotNil(presentedViewController)
    }
}

extension RecipeDetailsViewControllerTests {
    var foodImageView: UIImageView! {
        return recipeDetailsViewController.view.viewWithAccessibilityIdentifier(Constants.foodImageView, classType: UIImageView.self)!
    }

    var cuisineLabel: PaddedLabel! {
        return recipeDetailsViewController.view.viewWithAccessibilityIdentifier(Constants.cuisineLabel, classType: PaddedLabel.self)!
    }

    var nameLabel: UILabel! {
        return recipeDetailsViewController.view.viewWithAccessibilityIdentifier(Constants.nameLabel, classType: UILabel.self)!
    }

    var viewRecipeButton: UIButton! {
        return recipeDetailsViewController.view.viewWithAccessibilityIdentifier(Constants.viewRecipeButton, classType: UIButton.self)!
    }

    var watchVideoButton: UIButton! {
        return recipeDetailsViewController.view.viewWithAccessibilityIdentifier(Constants.watchVideoButton, classType: UIButton.self)!
    }
}


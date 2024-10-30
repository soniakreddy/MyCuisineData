//
//  RecipeTableViewCellTests.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//

import Testing
@testable import MyCuisineData
import XCTest

/// Unit tests for the `RecipeTableViewCell` class, validating its configuration with `Recipe` data.
/// Tests ensure that labels and image views display the correct information,
/// handle invalid or missing image URLs by showing placeholder images,
/// and confirm proper behavior across various scenarios.

class RecipeTableViewCellTests: XCTestCase {

    var cell: RecipeTableViewCell!
    var recipe: Recipe!

    override func setUp() {
        super.setUp()
        cell = RecipeTableViewCell()
        recipe = Recipe(cuisine: "Malaysian",
                        name: "Apam Balik",
                        photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                        photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                        sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                        youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        cell.layoutSubviews()
    }

    override func tearDown() {
        cell = nil
        recipe = nil
        super.tearDown()
    }

    func testConfigureLabels() {
        cell.configureLabels(recipe: recipe)

        XCTAssertEqual(cell.cuisineLabel.text, recipe.cuisine)
        XCTAssertEqual(cell.nameLabel.text, recipe.name)
        XCTAssertNotNil(cell.foodImageView.image)
    }

    func testConfigureLabelsWithInvalidImageUrl() {
        recipe = Recipe(cuisine: "Malaysian",
                        name: "Apam Balik",
                        photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                        photoUrlSmall: "invalid url",
                        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                        sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                        youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")

        cell.configureLabels(recipe: recipe)
        XCTAssertEqual(cell.foodImageView.image, Constants.placeholderImage)
    }

    func testConfigureLabelsWithNoImageUrl() {
        recipe = Recipe(cuisine: "Malaysian",
                        name: "Apam Balik",
                        photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                        photoUrlSmall: nil,
                        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                        sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                        youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")

        cell.configureLabels(recipe: recipe)
        XCTAssertEqual(cell.foodImageView.image, Constants.placeholderImage)
    }
}

extension RecipeTableViewCellTests {
    var foodImageView: UIImageView! {
        return cell.viewWithAccessibilityIdentifier(Constants.foodImageView, classType: UIImageView.self)!
    }

    var cuisineLabel: PaddedLabel! {
        return cell.viewWithAccessibilityIdentifier(Constants.cuisineLabel, classType: PaddedLabel.self)!
    }

    var nameLabel: UILabel! {
        return cell.viewWithAccessibilityIdentifier(Constants.nameLabel, classType: UILabel.self)!
    }
}

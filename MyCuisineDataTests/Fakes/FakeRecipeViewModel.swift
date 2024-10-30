//
//  FakeRecipeViewModel.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//
import Testing
@testable import MyCuisineData
import XCTest

/// `FakeRecipeViewModelDelegate` is a mock for testing the `RecipeViewModelDelegate` protocol,
/// tracking method calls and errors. `FakeRecipeViewModel` is a test subclass of `RecipeViewModel`
/// that uses fake data and simulates errors to verify delegate interactions during unit tests.

class FakeRecipeViewModelDelegate: RecipeViewModelDelegate {
    var didLoadRecipesCalled = false
    var didFailToLoadRecipesCalled = false
    var didUpdateFilteredRecipesCalled = false
    var errorReceived: APIServiceError?

    func didLoadRecipes() {
        didLoadRecipesCalled = true
    }

    func didFailToLoadRecipes(with error: APIServiceError) {
        didFailToLoadRecipesCalled = true
        errorReceived = error
    }

    func didUpdateFilteredRecipes() {
        didUpdateFilteredRecipesCalled = true
    }
}

class FakeRecipeViewModel: RecipeViewModel {
    var error: APIServiceError?
    private var finalRecipesList: [Recipe] = []
    var fakeRecipes: [Recipe] = []

    override var numberOfRecipes: Int {
        return finalRecipesList.count
    }

    override func recipe(at index: Int) -> Recipe {
        return finalRecipesList[index]
    }

    override func loadRecipes() {
        self.finalRecipesList = fakeRecipes
        guard let error = error else {
            delegate?.didLoadRecipes()
            return
        }
        delegate?.didFailToLoadRecipes(with: error)
    }

    override func filterRecipes(with searchText: String) {
        if searchText.isEmpty {
            finalRecipesList = fakeRecipes
        } else {
            finalRecipesList = fakeRecipes.filter { recipe in
                recipe.name.lowercased().contains(searchText.lowercased()) ||
                recipe.cuisine.lowercased().contains(searchText.lowercased())
            }
        }
        delegate?.didUpdateFilteredRecipes()
    }
}

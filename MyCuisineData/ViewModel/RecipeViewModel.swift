//
//  RecipesViewModel.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//

import Foundation

/// `RecipeViewModelDelegate` is a protocol that defines methods for notifying the delegate
/// about the status of recipe data loading and filtering. It includes callbacks for successful
/// data loading, failure to load data, and updates to the filtered recipe list.
///
/// `RecipeViewModel` is responsible for managing the recipe data, including loading recipes
/// from an API service and filtering the recipe list based on user input. It maintains an
/// internal state of the recipe data and utilizes a delegate to communicate changes
/// or errors back to the view controller or UI component.

protocol RecipeViewModelDelegate: AnyObject {
    func didLoadRecipes()
    func didFailToLoadRecipes(with error: APIServiceError)
    func didUpdateFilteredRecipes()
}

class RecipeViewModel {
    private var finalRecipesList: [Recipe] = []
    private var recipes: [Recipe] = []
    private var isFetchingData = false
    weak var delegate: RecipeViewModelDelegate?
    private let apiService: APIService

    // MARK: - Initializers
    init(apiService: APIService = .shared) {
        self.apiService = apiService
    }

    var numberOfRecipes: Int {
        return finalRecipesList.count
    }

    func recipe(at index: Int) -> Recipe {
        return finalRecipesList[index]
    }

    func loadRecipes() {
        guard !isFetchingData else { return }
        isFetchingData = true


        apiService.fetchData { [weak self] result in
            guard let self = self else { return }
            self.isFetchingData = false

            switch result {
                case .success(let recipesData):
                    self.recipes = recipesData.recipes
                    self.finalRecipesList = self.recipes
                    self.delegate?.didLoadRecipes()
                case .failure(let error):
                    self.delegate?.didFailToLoadRecipes(with: error)
            }
        }
    }

    func filterRecipes(with searchText: String) {
        if searchText.isEmpty {
            finalRecipesList = recipes
        } else {
            finalRecipesList = recipes.filter { recipe in
                recipe.name.lowercased().contains(searchText.lowercased()) ||
                recipe.cuisine.lowercased().contains(searchText.lowercased())
            }
        }
        delegate?.didUpdateFilteredRecipes()
    }
}

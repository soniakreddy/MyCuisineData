//
//  Constants.swift
//  MyCuisineData
//
//  Created by sokolli on 10/19/24.
//

import Foundation
import UIKit

/// `Constants.swift` defines a collection of static constants used throughout the application.

struct Constants {
    /// Url strings
    static let dataUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    static let malformedDataUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    static let emptyDataUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"

    /// Text strings
    static let titleText = NSLocalizedString("My Recipe Book", comment: "Title for the main view")
    static let searchBarPlaceHolderText = NSLocalizedString("Search recipes or cuisines", comment: "Placeholder text for the search bar in the recipes view")
    static let noRecipesAvailableText = NSLocalizedString("No recipes are available", comment: "Message displayed when there are no recipes to show")
    static let errorMessage = NSLocalizedString("There was an issue loading the data. Please try again later.", comment: "Error message shown when data fetching fails")
    static let errorTitle = NSLocalizedString("Data Error", comment: "Title for the error alert when data loading fails")
    static let okText = NSLocalizedString("OK", comment: "Text for the OK button in alerts")
    static let viewFullRecipeText = NSLocalizedString("View Full Recipe", comment: "Button text to navigate to the full recipe detail")
    static let viewVideoRecipeText = NSLocalizedString("View Video Recipe", comment: "Button text to view the video recipe")

    /// Identifiers
    static let emptyDataLabel = "emptyDataLabel"
    static let refreshControl = "refreshControl"
    static let searchBar = "searchBar"
    static let tableView = "tableView"
    static let foodImageView = "foodImageView"
    static let cuisineLabel = "cuisineLabel"
    static let nameLabel = "nameLabel"
    static let verticalStackView = "verticalStackView"
    static let horizontalStackView = "horizontalStackView"
    static let activityIndicator = "activityIndicator"
    static let webView = "webView"
    static let closeButton = "closeButton"
    static let viewRecipeButton = "viewRecipeButton"
    static let watchVideoButton = "watchVideoButton"
    static let cellIdentifier = "cellIdentifier"

    /// Icon name strings
    static let xmarkIcon = "xmark"
    static let arrowUpIcon = "arrow.up.forward.app"
    static let arrowTriangleIcon = "arrowtriangle.forward.circle"

    /// Placeholder image
    static let placeholderImage: UIImage? = UIImage(systemName: "fork.knife.circle")

    /// Colors
    static let darkPinkColor = UIColor(red: 194/256, green: 62/256, blue: 192/256, alpha: 1)
    static let blueColor = UIColor(red: 56/256, green: 207/256, blue: 236/256, alpha: 1)
    static let emeraldGreenColor = UIColor(red: 19/256, green: 180/256, blue: 113/256, alpha: 1)
    static let darkPurpleColor = UIColor(red: 66/256, green: 39/256, blue: 137/256, alpha: 1)
    static let lightGrayColor = UIColor(red: 199/256, green: 199/256, blue: 199/256, alpha: 1)
    static let mintGreenColor = UIColor(red: 184/256, green: 250/256, blue: 239/256, alpha: 1)
    static let greenColor = UIColor(red: 59/256, green: 170/256, blue: 62/256, alpha: 1)
    static let gradientColors: [CGColor] = [
        UIColor(red: 59/255, green: 7/255, blue: 100/255, alpha: 1).cgColor,
        UIColor(red: 30/255, green: 27/255, blue: 75/255, alpha: 1).cgColor,
        UIColor(red: 23/255, green: 37/255, blue: 84/255, alpha: 1).cgColor
    ]
}

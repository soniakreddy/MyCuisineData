//
//  ViewController.swift
//  MyCuisineData
//
//  Created by sokolli on 10/19/24.
//

import UIKit

/// This class manages and displays a list of recipes within a table view.
/// It includes features such as recipe filtering, data refresh, and search capabilities,
/// using MVVM (Model-View-ViewModel) for better data handling and separation of concerns.
///
/// Key functionalities:
/// - Fetches and displays a list of recipes using a table view with a customizable layout.
/// - Integrates a search bar to filter recipes in real-time based on user input.
/// - Provides a pull-to-refresh action to reload recipe data.
/// - Displays alerts in cases of network errors or malformed data.
/// - Manages navigation to detailed recipe views when a recipe is selected.
///
/// Components:
/// - `recipes` and `filteredRecipes`: Arrays to store all and filtered recipes.
/// - `viewModel`: The view model responsible for data management and updates.
/// - `refreshControl`: Provides pull-to-refresh functionality to reload data.
/// - `searchController`: Manages search bar input and display for filtering recipes.
/// - `emptyDataLabel`: Displays a message when no recipes are available.
/// - `tableView`: The main UI component displaying recipe information in a list format.

class ViewController: BaseViewController {
    /// MARK: - Properties
    private var recipes = [Recipe]()
    private var filteredRecipes = [Recipe]()
    var viewModel = RecipeViewModel()

    /// MARK: - UI Elements
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        refreshControl.tintColor = Constants.mintGreenColor
        refreshControl.accessibilityIdentifier = Constants.refreshControl
        return refreshControl
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: Constants.searchBarPlaceHolderText, attributes: [NSAttributedString.Key.foregroundColor: Constants.lightGrayColor])
        searchController.searchBar.tintColor = Constants.darkPinkColor
        if let searchIconView = searchController.searchBar.searchTextField.leftView as? UIImageView {
            searchIconView.tintColor = Constants.lightGrayColor
        }
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.isTranslucent = true
        searchController.searchBar.backgroundColor = .clear
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.searchBar.accessibilityIdentifier = Constants.searchBar

        return searchController
    }()

    private lazy var emptyDataLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Constants.darkPinkColor
        label.text = Constants.noRecipesAvailableText
        label.accessibilityIdentifier = Constants.emptyDataLabel
        label.isHidden = true
        return label
    }()

    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 110
        tableView.sectionHeaderTopPadding = 0
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.refreshControl = refreshControl
        tableView.accessibilityIdentifier = Constants.tableView
        return tableView
    }()

    /// MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.blueColor]
        title = "My Recipe Book"
        searchController.searchBar.searchTextField.textColor = Constants.mintGreenColor
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: Constants.mintGreenColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchTextField.tintColor = Constants.lightGrayColor
        searchController.searchBar.searchTextField.leftView?.tintColor = Constants.lightGrayColor
        searchController.searchBar.backgroundColor = UIColor.clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addSubview(emptyDataLabel)

        viewModel.delegate = self

        configureNavigationBar()
        addConstraints()
        loadData()
    }

    /// MARK: - Configuration
    /// Configures the navigation bar with title, searchController and titleTextAttibutes
    func configureNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:  Constants.darkPurpleColor]
        navigationController?.isNavigationBarHidden = false
        title = Constants.titleText
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    /// MARK: - Layout Constraints
    func addConstraints() {
        var customConstraints = [NSLayoutConstraint]()
        customConstraints.append(tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        customConstraints.append(tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        customConstraints.append(tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10))
        customConstraints.append(tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10))
        customConstraints.append(emptyDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        customConstraints.append(emptyDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        NSLayoutConstraint.activate(customConstraints)
    }

    /// Fetches recipes list from view model
    func loadData() {
        viewModel.loadRecipes()
    }

    /// Fetches recipes list from view model upon refresh
    @objc func onRefresh() {
        loadData()
    }

    /// Alert is displayed when a network call returns malformed data
    func showAlert() {
        let alert = UIAlertController(title: Constants.errorTitle, message: Constants.errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.okText, style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: RecipeViewModelDelegate {
    func didLoadRecipes() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func didFailToLoadRecipes(with error: APIServiceError) {
        DispatchQueue.main.async {
            if error == .malformedData {
                self.showAlert()
            }
            self.emptyDataLabel.isHidden = false
            self.refreshControl.endRefreshing()
        }
    }

    func didUpdateFilteredRecipes() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 5 : 20
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        return spacerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let recipe = viewModel.recipe(at: indexPath.section)
        let recipeDetailsViewController = RecipeDetailsViewController(recipe: recipe)
        navigationController?.pushViewController(recipeDetailsViewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    ///Setting cells to each section and number of row is 1 to get the spacing between each cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfRecipes
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        let recipe = viewModel.recipe(at: indexPath.section)
        recipeTableViewCell.configureLabels(recipe: recipe)
        return recipeTableViewCell
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterRecipes(with: searchText)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredRecipes = recipes
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

//
//  RecipeDetailsViewController.swift
//  MyCuisineData
//
//  Created by sokolli on 10/19/24.
//

import Foundation
import Kingfisher
import UIKit

/// A view controller responsible for displaying detailed information about a recipe.
/// Includes an image, cuisine label, recipe name, and buttons for viewing the full recipe or watching a video.

class RecipeDetailsViewController: BaseViewController {
    /// MARK: - Properties
    var recipe: Recipe?

    /// MARK: - UI Elements
    private lazy var foodImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.accessibilityIdentifier = Constants.foodImageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Constants.emeraldGreenColor
        imageView.backgroundColor = Constants.darkPurpleColor
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(250), for: .horizontal)
        return imageView
    }()

    private lazy var cuisineLabel: PaddedLabel = {
        let label = PaddedLabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.accessibilityIdentifier = Constants.cuisineLabel
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = Constants.greenColor
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Constants.darkPinkColor
        label.accessibilityIdentifier = Constants.nameLabel
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        let fontDescriptor = UIFont.preferredFont(forTextStyle: .largeTitle).fontDescriptor
        label.font = UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold) ?? fontDescriptor, size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
        return label
    }()

    private lazy var viewRecipeButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolImage = UIImage(systemName: Constants.arrowUpIcon)
        button.setImage(symbolImage, for: .normal)
        var configuration = UIButton.Configuration.filled()
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.imagePadding = 4
        button.tintColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(.white, for: .normal)
        button.setTitle(Constants.viewFullRecipeText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(viewRecipeButtonPressed(_:)), for: .touchUpInside)
        button.accessibilityIdentifier = Constants.viewRecipeButton
        button.backgroundColor?.withAlphaComponent(0)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    private lazy var watchVideoButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolImage = UIImage(systemName: Constants.arrowTriangleIcon)
        button.setImage(symbolImage, for: .normal)
        var configuration = UIButton.Configuration.filled()
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.imagePadding = 4
        button.tintColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle(Constants.viewVideoRecipeText, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(watchVideoButtonPressed(_:)), for: .touchUpInside)
        button.accessibilityIdentifier = Constants.watchVideoButton
        button.backgroundColor?.withAlphaComponent(0)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [viewRecipeButton, watchVideoButton])
        view.accessibilityIdentifier = Constants.horizontalStackView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 5
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()

    /// MARK: - Initializers
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(foodImageView)

        foodImageView.addSubview(cuisineLabel)
        foodImageView.addSubview(nameLabel)
        view.addSubview(horizontalStackView)

        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = Constants.mintGreenColor

        addConstraints()
        configureView()
        foodImageView.bringSubviewToFront(cuisineLabel)
        foodImageView.bringSubviewToFront(nameLabel)
    }

    /// MARK: - Layout Constraints
    func addConstraints() {
        var customConstraints = [NSLayoutConstraint]()
        customConstraints.append(viewRecipeButton.widthAnchor.constraint(equalTo: watchVideoButton.widthAnchor))
        customConstraints.append(viewRecipeButton.heightAnchor.constraint(equalTo: watchVideoButton.heightAnchor))
        customConstraints.append(foodImageView.topAnchor.constraint(equalTo: view.topAnchor))
        customConstraints.append(foodImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        customConstraints.append(foodImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        customConstraints.append(foodImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5))
        customConstraints.append(horizontalStackView.topAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: 25))
        customConstraints.append(nameLabel.leadingAnchor.constraint(equalTo: foodImageView.leadingAnchor, constant: 16))
        customConstraints.append(nameLabel.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: -16))
        customConstraints.append(nameLabel.bottomAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: -8))
        customConstraints.append(cuisineLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor))
        customConstraints.append(cuisineLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -4))

        customConstraints.append(horizontalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        customConstraints.append(horizontalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10))
        customConstraints.append(horizontalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10))
        NSLayoutConstraint.activate(customConstraints)
    }

    /// MARK: - Actions
    @objc private func viewRecipeButtonPressed(_ sender: UIButton) {
        guard let sourceUrl = recipe?.sourceUrl else { return }
        let modalViewController = ModalViewController(urlString: sourceUrl)
        modalViewController.modalPresentationStyle = .fullScreen
        present(modalViewController, animated: true, completion: nil)
    }

    @objc private func watchVideoButtonPressed(_ sender: UIButton) {
        guard let youtubeUrl = recipe?.youtubeUrl else { return }
        let modalViewController = ModalViewController(urlString: youtubeUrl)
        modalViewController.modalPresentationStyle = .fullScreen
        present(modalViewController, animated: true, completion: nil)
    }

    /// MARK: - Configuration
    /// Configure cell with the recipe data and set image for foodImageView using third-party package: Kingfisher
    func configureView() {
        cuisineLabel.text = recipe?.cuisine
        nameLabel.text = recipe?.name
        if let imageUrlString = recipe?.photoUrlLarge, let url = URL(string: imageUrlString) {
            foodImageView.kf.setImage(with: url, placeholder: Constants.placeholderImage)
        } else {
            foodImageView.image = Constants.placeholderImage
        }
    }
}

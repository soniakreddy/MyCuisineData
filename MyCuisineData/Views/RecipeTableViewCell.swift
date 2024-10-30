//
//  RecipeTableViewCell.swift
//  MyCuisineData
//
//  Created by sokolli on 10/19/24.
//

import Kingfisher
import UIKit

/// Custom UITableViewCell to display recipe details including an image, cuisine label, and name label.

class RecipeTableViewCell: UITableViewCell {
    /// MARK: - UI Elements
    lazy var foodImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.accessibilityIdentifier = Constants.foodImageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Constants.emeraldGreenColor
        imageView.backgroundColor = Constants.darkPurpleColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(250), for: .horizontal)
        return imageView
    }()

    lazy var cuisineLabel: PaddedLabel = {
        let label = PaddedLabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.accessibilityIdentifier = Constants.cuisineLabel
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = Constants.emeraldGreenColor
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Constants.darkPinkColor
        label.accessibilityIdentifier = Constants.nameLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [cuisineLabel, nameLabel])
        view.accessibilityIdentifier = Constants.verticalStackView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 5
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()

    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [foodImageView, verticalStackView])
        view.accessibilityIdentifier = Constants.horizontalStackView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 20
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()

    /// MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(horizontalStackView)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
        selectionStyle = .none
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }

    /// MARK: - Layout Constraints
    override func updateConstraints() {
        defer { super.updateConstraints() }

        var customConstraints = [NSLayoutConstraint]()
        customConstraints.append(foodImageView.widthAnchor.constraint(equalToConstant: 100))
        customConstraints.append(horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10))
        customConstraints.append(horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10))
        customConstraints.append(horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10))
        customConstraints.append(horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10))
        customConstraints.append(horizontalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        NSLayoutConstraint.activate(customConstraints)
    }

    /// MARK: - Configuration
    /// Configure cell with the recipe data and set image for foodImageView using third-party package: Kingfisher
    func configureLabels(recipe: Recipe) {
        cuisineLabel.text = recipe.cuisine
        nameLabel.text = recipe.name

        if let imageUrlString = recipe.photoUrlSmall, let url = URL(string: imageUrlString) {
            foodImageView.kf.setImage(with: url, placeholder: Constants.placeholderImage)
        } else {
            foodImageView.image = Constants.placeholderImage
        }
    }

}

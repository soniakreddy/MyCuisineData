//
//  BaseViewController.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//

import UIKit

/// A base UIViewController subclass that provides a gradient background setup.

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientBackground()
    }

    ///Creates and inserts a gradient layer with colors, locations, and start/end points from `Constants`.
    func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = Constants.gradientColors
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    ///Adjusts the gradient layer's frame to match the view's bounds after layout changes.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
}

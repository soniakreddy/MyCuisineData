//
//  UIVIew+Extension.swift
//  MyCuisineData
//
//  Created by sokolli on 10/28/24.
//

import UIKit

/// This extension on `UIView` provides a method to recursively search for a subview
/// with a specified accessibility identifier. It includes a non-generic method that
/// returns any `UIView` with the matching identifier, and a generic method that
/// returns a specific subclass of `UIView`, allowing for type-safe access to the
/// found view.

extension UIView {
    @nonobjc public func viewWithAccessibilityIdentifier(_ accessibilityIdentifier: String) -> UIView? {
        return viewWithAccessibilityIdentifier(accessibilityIdentifier, classType: UIView.self)
    }

    @nonobjc public func viewWithAccessibilityIdentifier<T: UIView>(_ accessibilityIdentifier: String, classType: T.Type) -> T? {
        if let selfObject = self as? T, self.accessibilityIdentifier == accessibilityIdentifier {
            return selfObject
        }

        for subview in self.subviews {
            if let match = subview.viewWithAccessibilityIdentifier(accessibilityIdentifier, classType: classType) {
                return match
            }
        }

        return nil
    }
}

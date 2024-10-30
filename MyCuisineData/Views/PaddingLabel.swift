//
//  PaddingLabel.swift
//  MyCuisineData
//
//  Created by sokolli on 10/20/24.
//
import UIKit

/// A custom UILabel that adds padding around the label's text.

class PaddedLabel: UILabel {
    /// MARK: - Properties
    var textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

    ///Adjusts the text drawing area based on `textInsets`
    override func drawText(in rect: CGRect) {
        let insetsRect = rect.inset(by: textInsets)
        super.drawText(in: insetsRect)
    }

    ///Expands the label’s intrinsic content size to accommodate padding.
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}

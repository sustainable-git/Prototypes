//
//  PaddedLabel.swift
//  FoodApp
//
//  Created by shin jae ung on 2021/12/31.
//

import UIKit

final class PaddedLabel: UILabel {
    var insets = UIEdgeInsets(top: 2, left: 20, bottom: 2, right: 20)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += self.insets.top + self.insets.bottom
            contentSize.width += self.insets.left + self.insets.right
            return contentSize
        }
    }
}

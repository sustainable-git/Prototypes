//
//  AppStoreButton.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/10.
//

import UIKit

final class AppStoreButton: UIButton {
    private let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    private var cellSize: CGSize {
        let button = UIButton()
        button.setTitle("₩99,000", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        return CGSize(
            width: button.intrinsicContentSize.width + self.insets.left + self.insets.right,
            height: button.intrinsicContentSize.height + self.insets.top + self.insets.bottom
        )
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.clipsToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2
    }
    
    override var intrinsicContentSize: CGSize {
        self.cellSize
    }
}

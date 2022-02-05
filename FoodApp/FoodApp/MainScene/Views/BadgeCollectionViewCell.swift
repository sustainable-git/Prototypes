//
//  BadgeCollectionViewCell.swift
//  FoodApp
//
//  Created by shin jae ung on 2021/12/31.
//

import UIKit

final class BadgeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var badgeName: UILabel!
    
    static let identifier = String(describing: BadgeCollectionViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: BadgeCollectionViewCell.identifier, bundle: nil)
    }
    
    override func prepareForReuse() {
        self.badgeName.text = ""
    }
    
    func configure(badgeName: String) {
        self.badgeName.text = badgeName
    }
}

//
//  DetailViewDescriptionCell.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/09.
//

import UIKit

final class DetailViewDescriptionCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!
    
    static let identifier = String(describing: DetailViewDescriptionCell.self)
    static func nib() -> UINib {
        return UINib(nibName: DetailViewDescriptionCell.identifier, bundle: nil)
    }
    
    func configre(text: String) {
        self.label.text = text
    }
}

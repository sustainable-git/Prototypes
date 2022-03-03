//
//  DetailViewHeadCell.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/09.
//

import UIKit

final class DetailViewHeadCell: UICollectionViewCell {
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var price: UIButton!
    var task: URLSessionDownloadTask?
    
    static let identifier = String(describing: DetailViewHeadCell.self)
    static func nib() -> UINib {
        return UINib(nibName: DetailViewHeadCell.identifier, bundle: nil)
    }
    
    deinit {
        self.task?.cancel()
    }
    
    func configure(title: String, price: String) {
        self.title.text = title
        self.price.setTitle(price, for: .normal)
    }
    
    func configure(mainImage: URL) {
        guard let uiimage = UIImage(contentsOfFile: mainImage.path) else { return }
        DispatchQueue.main.async {
            self.image.image = uiimage
        }
    }
}

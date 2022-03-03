//
//  MainCollectionViewCell.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/08.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var stars: UILabel!
    @IBOutlet private weak var price: UIButton!
    var task: URLSessionDownloadTask?
    
    static let identifier = String(describing: MainCollectionViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: MainCollectionViewCell.identifier, bundle: nil)
    }
    
    override func prepareForReuse() {
        self.image.image = UIImage(systemName: "slowmo")
        self.task?.cancel()
    }
    
    func configure(title: String, price: String, rating: String) {
        self.title.text = title
        self.price.setTitle(price, for: .normal)
        self.stars.text = rating
    }
    
    func configure(image: URL) {
        guard let uiimage = UIImage(contentsOfFile: image.path) else { return }
        DispatchQueue.main.async {
            self.image.image = uiimage
        }
    }
}

//
//  DetailViewScreenshotCell.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/09.
//

import UIKit

final class DetailViewScreenshotCell: UICollectionViewCell {
    @IBOutlet private weak var image: UIImageView!
    var task: URLSessionDownloadTask?
    
    static let identifier = String(describing: DetailViewScreenshotCell.self)
    static func nib() -> UINib {
        return UINib(nibName: DetailViewScreenshotCell.identifier, bundle: nil)
    }
    
    override func prepareForReuse() {
        self.image.image = UIImage(systemName: "slowmo")
        self.task?.cancel()
    }
    
    deinit {
        self.task?.cancel()
    }
    
    func configure(screenShotImage: URL) {
        guard let uiimage = UIImage(contentsOfFile: screenShotImage.path) else { return }
        DispatchQueue.main.async {
            self.image.image = uiimage
        }
    }
}

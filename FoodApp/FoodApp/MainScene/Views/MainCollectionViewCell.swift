//
//  MainCollectionViewCell.swift
//  FoodApp
//
//  Created by shin jae ung on 2021/12/31.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var badgeCollectionView: UICollectionView!
    private var badges: [String]?
    
    static let identifier = String(describing: MainCollectionViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: MainCollectionViewCell.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.badgeCollectionView.register(
            BadgeCollectionViewCell.nib(),
            forCellWithReuseIdentifier: BadgeCollectionViewCell.identifier
        )
        self.badgeCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        if let flowLayout = badgeCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        self.badgeCollectionView.dataSource = self
        self.badgeCollectionView.delegate = self
    }
    
    func configure(imageName: String, title: String, badges: [String]) {
        self.imageView.image = UIImage(named: imageName)
        self.title.text = title
        self.badges = badges
        self.badgeCollectionView.reloadData()
    }
}

extension MainCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.badges?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BadgeCollectionViewCell.identifier,
            for: indexPath
        ) as? BadgeCollectionViewCell,
              let badgeName = self.badges?[indexPath.item]
        else{
            return UICollectionViewCell()
        }
        cell.configure(badgeName: badgeName)
        
        return cell
    }
}

extension MainCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let badges = badges else { return .zero }
        let label = PaddedLabel(frame: .zero)
        label.text = badges[indexPath.item]
        label.font = .boldSystemFont(ofSize: 12)
        return label.intrinsicContentSize
    }
}

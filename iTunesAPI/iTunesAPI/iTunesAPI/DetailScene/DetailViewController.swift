//
//  DetailViewController.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/09.
//

import UIKit

protocol Popable: AnyObject {
    func viewWillPop()
}

final class DetailViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var viewModel: DetailViewModel?
    private weak var navigationDelegate: Popable?

    convenience init(viewModel: DetailViewModel, navigator: Popable) {
        self.init()
        self.viewModel = viewModel
        self.navigationDelegate = navigator
    }
    
    deinit {
        self.navigationDelegate?.viewWillPop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureCollectionView()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] sectionNumber, _ in
            switch sectionNumber {
            case 0: return self?.headLayoutSection()
            case 1: return self?.screenshotLayoutSection()
            default: return self?.descriptionLayoutSection()
            }
        }
        self.collectionView.register(
            DetailViewHeadCell.nib(),
            forCellWithReuseIdentifier: DetailViewHeadCell.identifier
        )
        self.collectionView.register(
            DetailViewScreenshotCell.nib(),
            forCellWithReuseIdentifier: DetailViewScreenshotCell.identifier
        )
        self.collectionView.register(
            DetailViewDescriptionCell.nib(),
            forCellWithReuseIdentifier: DetailViewDescriptionCell.identifier
        )
        self.collectionView.dataSource = self
    }
    
    private func headLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func screenshotLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(245), heightDimension: .estimated(435))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func descriptionLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return self.viewModel?.numberOfScreenShots ?? 0
        case 2: return 1
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailViewHeadCell.identifier,
                for: indexPath
            ) as? DetailViewHeadCell,
               let appMainInfo = self.viewModel?.appMainInfo() {
                cell.configure(title: appMainInfo.title, price: appMainInfo.price)
                let task = self.viewModel?.appMainImage { url in
                    guard let url = url else { return }
                    cell.configure(mainImage: url)
                }
                cell.task = task
                return cell
            }
        case 1:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailViewScreenshotCell.identifier,
                for: indexPath
            ) as? DetailViewScreenshotCell {
                let task = self.viewModel?.appScreenShotImage(of: indexPath) { url in
                    guard let url = url else { return }
                    cell.configure(screenShotImage: url)
                }
                cell.task = task
                return cell
            }
        case 2:
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailViewDescriptionCell.identifier,
                for: indexPath
            ) as? DetailViewDescriptionCell,
               let appDescription = self.viewModel?.appDescription() {
                cell.configre(text: appDescription)
                return cell
            }
            break
        default:
            break
        }
        return UICollectionViewCell()
    }
}

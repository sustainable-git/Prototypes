//
//  MainViewController.swift
//  FoodApp
//
//  Created by shin jae ung on 2021/12/31.
//

import UIKit

protocol Navigatable: AnyObject {
    func didSelectFood(_ foodEntity: FoodEntity)
}

final class MainViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: MainViewModel?
    weak var navigationDelegate: Navigatable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func configureViewModel() {
        self.reloadButtonTouched(nil)
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.compositionalLayout()
        }
        self.collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        self.collectionView.register(
            MainCollectionViewCell.nib(),
            forCellWithReuseIdentifier: MainCollectionViewCell.identifier
        )
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func compositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    @IBAction func reloadButtonTouched(_ sender: UIButton?) {
        self.viewModel?.loadMenu { [weak self] void in
            if void == nil {
                // TODO: show error messages
            } else {
                self?.collectionView.reloadData()
                guard self?.collectionView.numberOfItems(inSection: 0) ?? 0 > 0 else { return }
                self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 6 }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCollectionViewCell.identifier,
            for: indexPath
        ) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let image = self.viewModel?.foodImage(of: indexPath),
              let title = self.viewModel?.foodTitle(of: indexPath),
              let badges = self.viewModel?.foodBadges(of: indexPath)
        else {
            return cell
        }
        
        cell.configure(imageName: image, title: title, badges: badges)
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let food = viewModel?.foodEntities?[indexPath.item] else { return }
        self.navigationDelegate?.didSelectFood(food)
    }
}

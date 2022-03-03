//
//  MainViewController.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/08.
//

import UIKit

protocol Navigatable: AnyObject {
    func didSelectApp(_ app: App)
}

final class MainViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var viewModel: MainViewModel?
    private var workItem: DispatchWorkItem?
    private weak var navigationDelegate: Navigatable?
    
    convenience init(viewModel: MainViewModel, navigator: Navigatable) {
        self.init()
        self.viewModel = viewModel
        self.navigationDelegate = navigator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSearchBar()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("searchTitle", comment: "")
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = NSLocalizedString("searchPlaceHolder", comment: "")
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.compositionalLayout()
        }
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        return viewModel.applications?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCollectionViewCell.identifier,
            for: indexPath
        ) as? MainCollectionViewCell,
              let appInfo = self.viewModel?.appInfo(of: indexPath)
        else {
            return UICollectionViewCell()
        }
        cell.configure(title: appInfo.title, price: appInfo.price, rating: appInfo.rating)
        let task = self.viewModel?.image(of: indexPath) { url in
            guard let url = url else { return }
            cell.configure(image: url)
        }
        cell.task = task
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let app = self.viewModel?.app(of: indexPath) else { return }
        self.navigationDelegate?.didSelectApp(app)
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.workItem?.cancel()
        let newWorkItem = DispatchWorkItem(block: {
            self.viewModel?.search(text) { [weak self] void in
                if void == nil {
                    // TODO: show error messages
                } else {
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
            }
        })
        self.workItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: newWorkItem)
    }
}

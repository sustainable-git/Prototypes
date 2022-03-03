//
//  DetailViewCoordinator.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/09.
//

import UIKit

final class DetailViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let app: App
    private let networkService: NetworkService
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController, networkService: NetworkService, app: App) {
        self.navigationController = navigationController
        self.networkService = networkService
        self.app = app
    }
    
    func start() {
        let viewController = DetailViewController(viewModel: self.injectDependencies(), navigator: self)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension DetailViewCoordinator {
    private func injectDependencies() -> DetailViewModel {
        return DetailViewModel(
            imageFetchUseCase:
                ImageFetchUseCase(
                    ImageDownloadRepository(
                        self.networkService
                    )
                ),
            app: self.app
        )
    }
}

extension DetailViewCoordinator: Popable {
    func viewWillPop() {
        self.parentCoordinator?.childCoordinators.removeLast()
    }
}

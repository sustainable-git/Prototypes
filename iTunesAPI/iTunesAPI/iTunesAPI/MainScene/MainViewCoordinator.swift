//
//  MainViewCoordinator.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/08.
//

import UIKit

final class MainViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let networkService: NetworkService
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController, networkService: NetworkService) {
        self.navigationController = navigationController
        self.networkService = networkService
    }
    
    func start() {
        let viewController = MainViewController(viewModel: injectDependencies(), navigator: self)
        self.navigationController.pushViewController(viewController, animated: false)
    }
}

extension MainViewCoordinator {
    private func injectDependencies() -> MainViewModel {
        return MainViewModel(
            AppStoreFetchUseCase(
                AppStoreFetchRepository(
                    self.networkService
                )
            ),
            ImageFetchUseCase(
                ImageDownloadRepository(
                    self.networkService
                )
            )
        )
    }
}

extension MainViewCoordinator: Navigatable {
    func didSelectApp(_ app: App) {
        let detailViewCoordinator = DetailViewCoordinator(
            navigationController: self.navigationController,
            networkService: self.networkService,
            app: app
        )
        detailViewCoordinator.parentCoordinator = self
        self.childCoordinators.append(detailViewCoordinator)
        detailViewCoordinator.start()
    }
}

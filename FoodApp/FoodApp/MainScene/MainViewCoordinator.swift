//
//  MainViewCoordinator.swift
//  FoodApp
//
//  Created by shin jae ung on 2021/12/31.
//

import UIKit

final class MainViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?

    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = MainViewController(nibName: "MainViewController", bundle: nil)
        viewController.navigationDelegate = self
        self.injectDependencies(to: viewController)
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(viewController, animated: false)
    }
}

extension MainViewCoordinator {
    private func injectDependencies(to viewController: MainViewController) {
        viewController.viewModel = MainViewModel(
            MainViewUseCase(
                MainViewRepository(
                    MainViewService()
                )
            )
        )
    }
}

extension MainViewCoordinator: Navigatable {
    func didSelectFood(_ foodEntity: FoodEntity) {
        let menuViewCoordinator = MenuViewCoordinator(navigationController: self.navigationController, foodEntity: foodEntity)
        menuViewCoordinator.parentCoordinator = self
        self.childCoordinators.append(menuViewCoordinator)
        menuViewCoordinator.start()
    }
}


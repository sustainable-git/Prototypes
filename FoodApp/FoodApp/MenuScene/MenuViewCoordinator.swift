//
//  MenuViewCoordinator.swift
//  FoodApp
//
//  Created by shin jae ung on 2022/01/01.
//

import UIKit

final class MenuViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let foodEntity: FoodEntity
    weak var parentCoordinator: Coordinator?

    init(navigationController: UINavigationController, foodEntity: FoodEntity){
        self.navigationController = navigationController
        self.foodEntity = foodEntity
    }
    
    func start() {
        let viewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        viewController.popDelegate = self
        self.injectDependencies(to: viewController)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

extension MenuViewCoordinator {
    private func injectDependencies(to viewController: MenuViewController) {
        viewController.viewModel = MenuViewModel(self.foodEntity)
    }
}

extension MenuViewCoordinator: Popable {
    func viewDidPop() {
        parentCoordinator?.childCoordinators.removeLast()
    }
}

//
//  AppCoordinator.swift
//  FoodApp
//
//  Created by shin jae ung on 2021/12/31.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = UINavigationController()
    let window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
        window?.makeKeyAndVisible()
    }
    
    func start() {
        let mainViewCoordinator = MainViewCoordinator(navigationController: self.navigationController)
        mainViewCoordinator.parentCoordinator = self
        self.childCoordinators.append(mainViewCoordinator)
        mainViewCoordinator.start()
        self.window?.rootViewController = navigationController
    }
}

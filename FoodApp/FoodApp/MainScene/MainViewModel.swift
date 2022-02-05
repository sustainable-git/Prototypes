//
//  MainViewModel.swift
//  FoodApp
//
//  Created by shin jae ung on 2021/12/31.
//

import Foundation

final class MainViewModel {
    private let useCase: MainViewUseCase
    private(set) var foodEntities: [FoodEntity]?
    
    init(_ useCase: MainViewUseCase) {
        self.useCase = useCase
    }
    
    func loadMenu(completion: @escaping (Void?) -> Void) {
        self.useCase.fetchFoodInfo { [weak self] foodEntities in
            guard let foodEntities = foodEntities else {
                completion(nil)
                return
            }
            self?.foodEntities = foodEntities
            completion(Void())
        }
    }
    
    func foodImage(of indexPath: IndexPath) -> String? {
        return foodEntities?[indexPath.item].imageName
    }
    
    func foodTitle(of indexPath: IndexPath) -> String? {
        return foodEntities?[indexPath.item].title
    }
    
    func foodBadges(of indexPath: IndexPath) -> [String]? {
        return foodEntities?[indexPath.item].badges
    }
}

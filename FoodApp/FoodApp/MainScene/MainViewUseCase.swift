//
//  MainViewUseCase.swift
//  FoodApp
//
//  Created by shin jae ung on 2021/12/31.
//

import Foundation
import OSLog

final class MainViewUseCase {
    private let repository: RandomFoodsRepository
    
    init(_ repository: RandomFoodsRepository) {
        self.repository = repository
    }
    
    func fetchFoodInfo(completion: @escaping ([FoodEntity]?) -> Void) {
        self.repository.request { result in
            switch result {
            case .failure(let error):
                os_log(.error, log: .default, "\(error.localizedDescription)")
                completion(nil)
            case .success(let entities):
                completion(entities)
            }
        }
    }
}

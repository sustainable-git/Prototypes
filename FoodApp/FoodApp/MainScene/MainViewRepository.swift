//
//  MainViewRepository.swift
//  FoodApp
//
//  Created by shin jae ung on 2021/12/31.
//

import Foundation
import UIKit

protocol RandomFoodsRepository {
    func request(completion: @escaping (Result<[FoodEntity], Error>) -> Void)
}

final class MainViewRepository: RandomFoodsRepository {
    private let service: NetworkService
    
    init(_ service: NetworkService) {
        self.service = service
    }
    
    func request(completion: @escaping (Result<[FoodEntity], Error>) -> Void) {
        self.service.randomFoodsRequest { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                var foodEntities: [FoodEntity] = []
                data.forEach {
                    let food = FoodEntity(imageName: $0[0], title: $0[1], badges: Array($0[2...]))
                    foodEntities.append(food)
                }
                completion(.success(foodEntities))
            }
        }
    }
}

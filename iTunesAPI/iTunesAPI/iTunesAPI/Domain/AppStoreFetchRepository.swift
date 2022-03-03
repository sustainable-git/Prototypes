//
//  MainViewRepository.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/08.
//

import Foundation
import CryptoKit

protocol AppStoreFetchable {
    func fetchApplications(_ string: String, completion: @escaping (Result<Applications, Error>) -> Void)
}

final class AppStoreFetchRepository: AppStoreFetchable {
    enum RepositoryError: Error {
        case serializationError
    }
    
    private let service: NetworkService
    
    init(_ service: NetworkService) {
        self.service = service
    }
    
    func fetchApplications(_ string: String, completion: @escaping (Result<Applications, Error>) -> Void) {
        self.service.get(string) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                guard let applications = try? JSONDecoder().decode(Applications.self, from: data) else {
                    completion(.failure(RepositoryError.serializationError))
                    return
                }
                completion(.success(applications))
            }
        }
    }
}


//
//  MainViewUseCase.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/08.
//

import Foundation
import OSLog

final class AppStoreFetchUseCase {
    private let repository: AppStoreFetchable
    
    init(_ repository: AppStoreFetchable) {
        self.repository = repository
    }
    
    func fetch(_ string: String, completion: @escaping (Applications?) -> Void) {
        self.repository.fetchApplications(string) { result in
            switch result {
            case .failure(let error):
                if #available(iOS 14.0, *) {
                    os_log(.error, log: .default, "\(error.localizedDescription)")
                }
                completion(nil)
            case .success(let applications):
                completion(applications)
            }
        }
    }
}

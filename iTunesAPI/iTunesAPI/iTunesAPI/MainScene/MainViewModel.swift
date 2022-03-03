//
//  MainViewModel.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/08.
//

import Foundation

final class MainViewModel {
    private let appStoreFetchUseCase: AppStoreFetchUseCase
    private let imageFetchUseCase: ImageFetchUseCase
    private(set) var applications: Applications?
    
    init(_ appStoreFetchUseCase: AppStoreFetchUseCase, _ imageFetchUseCase: ImageFetchUseCase) {
        self.appStoreFetchUseCase = appStoreFetchUseCase
        self.imageFetchUseCase = imageFetchUseCase
    }
    
    func search(_ string: String, completion: @escaping (Void?) -> Void) {
        self.appStoreFetchUseCase.fetch(string) { applications in
            guard let applications = applications else {
                completion(nil)
                return
            }
            self.applications = applications
            completion(Void())
        }
    }
    
    func app(of indexPath: IndexPath) -> App? {
        guard let applications = self.applications,
              indexPath.item <= applications.apps.count else { return nil }
        return self.applications?.apps[indexPath.item]
    }
    
    func appInfo(of indexPath: IndexPath) -> (title: String, price: String, rating: String)? {
        guard let app = self.app(of: indexPath) else { return nil }
        let rating = NSLocalizedString("userRating", comment: "") + String(format: " : %.2f", app.rating)
        return (app.title, app.price, rating)
    }
    
    func image(of indexPath: IndexPath, completion: @escaping (URL?) -> Void) -> URLSessionDownloadTask? {
        guard let app = self.applications?.apps[indexPath.item] else {
            completion(nil)
            return nil
        }
        return self.imageFetchUseCase.fetchImage(app.thumbnailURL) { url in
            guard let url = url else {
                completion(nil)
                return
            }
            completion(url)
        }
    }
}

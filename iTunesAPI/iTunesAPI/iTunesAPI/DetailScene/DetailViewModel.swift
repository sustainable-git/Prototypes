//
//  DetailViewModel.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/09.
//

import Foundation

final class DetailViewModel {
    private let imageFetchUseCase: ImageFetchUseCase
    private let app: App
    var numberOfScreenShots: Int {
        self.app.screenShotURLs.count
    }
    
    init(imageFetchUseCase: ImageFetchUseCase, app: App) {
        self.imageFetchUseCase = imageFetchUseCase
        self.app = app
    }
    
    func appMainImage(completion: @escaping(URL?) -> Void) -> URLSessionDownloadTask? {
        return self.imageFetchUseCase.fetchImage(self.app.thumbnailURL) { url in
            guard let url = url else {
                completion(nil)
                return
            }
            completion(url)
        }
    }
    
    func appMainInfo() -> (title: String, price: String) {
        return (self.app.title, self.app.price)
    }
    
    func appScreenShotImage(of indexPath: IndexPath, completion: @escaping(URL?) -> Void) -> URLSessionDownloadTask? {
        guard indexPath.section == 1, indexPath.item <= self.app.screenShotURLs.count else {
            completion(nil)
            return nil
        }
        return self.imageFetchUseCase.fetchImage(self.app.screenShotURLs[indexPath.item]) { url in
            guard let url = url else {
                completion(nil)
                return
            }
            completion(url)
        }
    }
    
    func appDescription() -> String {
        return self.app.details
    }
}

//
//  ImageFetchUseCase.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/10.
//

import Foundation
import OSLog

final class ImageFetchUseCase {
    private let repository: ImageDownloadable
    
    init(_ repository: ImageDownloadable) {
        self.repository = repository
    }
    
    func fetchImage(_ string: String, completion: @escaping (URL?) -> Void) -> URLSessionDownloadTask? {
        return self.repository.fetchImageURL(string) { result in
            switch result {
            case .failure(let error):
                if #available(iOS 14.0, *) {
                    os_log(.error, log: .default, "\(error.localizedDescription)")
                }
                completion(nil)
            case .success(let url):
                completion(url)
            }
        }
    }
}

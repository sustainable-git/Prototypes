//
//  ImageDownloadRepository.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/10.
//

import Foundation
import CryptoKit

protocol ImageDownloadable {
    func fetchImageURL(_ string: String, completion: @escaping (Result<URL, Error>) -> Void) -> URLSessionDownloadTask?
}

final class ImageDownloadRepository: ImageDownloadable {
    private let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    private let service: NetworkService
    
    init(_ service: NetworkService) {
        self.service = service
    }
    
    func fetchImageURL(_ string: String, completion: @escaping (Result<URL, Error>) -> Void) -> URLSessionDownloadTask? {
        var cache = self.cacheDirectory
        cache.appendPathComponent(string.MD5)
        
        if FileManager.default.fileExists(atPath: cache.path) {
            completion(.success(cache))
            return nil
        } else {
            let task = self.service.download(string) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let url):
                    completion(result)
                    try? FileManager.default.copyItem(at: url, to: cache)
                }
            }
            return task
        }
    }
}

fileprivate extension String {
    var MD5: String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}


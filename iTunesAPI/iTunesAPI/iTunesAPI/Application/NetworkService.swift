//
//  MainViewService.swift
//  iTunesAPI
//
//  Created by shin jae ung on 2022/01/08.
//

import Foundation
import NetworkManager

protocol NetworkService {
    func get(_ string: String, completion: @escaping (Result<Data, Error>) -> Void)
    func download(_ string: String, completion: @escaping (Result<URL, Error>) -> Void) -> URLSessionDownloadTask?
}

final class DefaultNetworkService: NetworkService {
    enum ServiceError: Error {
        case cacheDirectoryUnavailableError
    }
    
    private let networkManager = NetworkManager()
    
    func get(_ string: String, completion: @escaping (Result<Data, Error>) -> Void) {
        self.networkManager.get(string, completion: completion)
    }
    
    func download(_ string: String, completion: @escaping (Result<URL, Error>) -> Void) -> URLSessionDownloadTask? {
        return self.networkManager.download(string, completion: completion)
    }
}

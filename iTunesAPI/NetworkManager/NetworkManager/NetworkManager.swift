//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by shin jae ung on 2022/01/08.
//

import Foundation

public class NetworkManager {
    enum NetworkError: Error {
        case invalidURLError
        case requestError
        case invalidResponseError
        case unsuccessfulResponseError
        case invalidDataError
    }
    
    public init() {}
    
    public func get(_ string: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard var urlRequest = Endpoint(term: string).request else {
            completion(.failure(NetworkError.invalidURLError))
            return
        }
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        self.dataTask(with: urlRequest, completion: completion)
    }
    
    public func download(_ string: String, completion: @escaping (Result<URL, Error>) -> Void) -> URLSessionDownloadTask? {
        guard let url = URL(string: string) else {
            completion(.failure(NetworkError.invalidURLError))
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return self.downloadTask(with: urlRequest, completion: completion)
    }
    
    private func dataTask(with urlRequest: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.requestError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponseError))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.unsuccessfulResponseError))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.invalidDataError))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    private func downloadTask(with urlRequest: URLRequest, completion: @escaping (Result<URL, Error>) -> Void) -> URLSessionDownloadTask {
        let task = URLSession.shared.downloadTask(with: urlRequest) { url, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.requestError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponseError))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.unsuccessfulResponseError))
                return
            }
            guard let url = url else {
                completion(.failure(NetworkError.invalidDataError))
                return
            }
            completion(.success(url))
        }
        task.resume()
        return task
    }
    
    private struct Endpoint {
        private var term: String
        private var baseURL: String = "https://itunes.apple.com"
        private var path: String = "/search"
        private var regionCode: String? {
            return Locale.current.regionCode
        }
        
        init(term: String) {
            self.term = term
        }
        
        var request: URLRequest? {
            var components = URLComponents(string: baseURL)
            components?.path = path
            components?.queryItems = [
                URLQueryItem(name: "entity", value: "software"),
                URLQueryItem(name: "term", value: term)
            ]
            if let regionCode = self.regionCode {
                let item = URLQueryItem(name: "country", value: regionCode)
                components?.queryItems?.append(item)
            }
            
            guard let url = components?.url else { return nil }
            return URLRequest(url: url)
        }
    }
}

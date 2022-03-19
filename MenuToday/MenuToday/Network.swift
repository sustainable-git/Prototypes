//
//  Network.swift
//  MenuToday
//
//  Created by Shin Jae Ung on 2022/03/18.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case unsucessfulResponse
    case invalidData
}

enum SerializationError: Error {
    case unavailable
}

func get(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(.failure(NetworkError.invalidURL))
        return
    }
    var urlRequest = URLRequest.init(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.addValue("*/*", forHTTPHeaderField: "accept")
    dataTask(with: urlRequest, completion: completion)
}

func dataTask(with urlRequest: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        guard error == nil else {
            completion(.failure(NetworkError.requestFailed))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(NetworkError.unsucessfulResponse))
            return
        }
        guard let data = data else {
            completion(.failure(NetworkError.invalidData))
            return
        }
        completion(.success(data))
    }.resume()
}

func fetchURL(_ urlString: String, completion: @escaping (Result<Menu, Error>) -> Void) {
    get(urlString) { result in
        switch result {
        case .success(let data):
            guard let meals = try? JSONDecoder().decode([Meal].self, from: data) else {
                completion(.failure(SerializationError.unavailable))
                return
            }
            completion(.success(Menu(meals: meals)))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}


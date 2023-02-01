//
//  APIRequest.swift
//  KittyFacts
//
//  Created by Swapnil Ratnaparkhi on 1/31/23.
//

import Foundation
import UIKit

protocol APIProvider {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    func makeRequest(url: URL, completion: @escaping Handler)
}

struct WebAPIRequest {
    private let apiProvider: APIProvider
    init(_ provider: APIProvider = URLSession.shared) {
        self.apiProvider = provider
    }
    
    func Request<T: Decodable>(_ url: URL,_ model: T.Type, completion: @escaping (T?, APIError?)-> Void) {
        apiProvider.makeRequest(url: url) { data, response, error in
            guard let data = data else {
                completion(nil, .errorResponse)
                return
            }
            do {
                let result: T = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            }
            catch {
                completion(nil, .errorParsing)
            }
        }
    }
    
    
    func DownloadRequest(_ url: URL, completion: @escaping (Data?, APIError?) -> Void) {
        apiProvider.makeRequest(url: url) { data, response, error in
            guard let data = data else {
                completion(nil, .errorResponse)
                return
            }
            completion(data, nil)
        }
    }
}

extension URLSession: APIProvider {
    typealias Handler = APIProvider.Handler
    func makeRequest(url: URL, completion: @escaping Handler) {
        self.configuration.timeoutIntervalForRequest = 3.0
        let task = dataTask(with: url, completionHandler: completion)
        task.resume()
    }
    
}


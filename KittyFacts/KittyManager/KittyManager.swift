//
//  KittyManager.swift
//  KittyFacts
//
//  Created by Swapnil Ratnaparkhi on 1/31/23.
//

import Foundation
import UIKit

protocol KittyManagerDelegate {
    func kittyDescription(completionHandler: @escaping (KittyDescription?, APIError?)-> Void)
    func kittyImage(completionHandler: @escaping (Data?, APIError?)-> Void)
}

struct KittyNetworkManager: KittyManagerDelegate {
    let webApiRequest: WebAPIRequest
    
    init(_ webApiRequest: WebAPIRequest = WebAPIRequest()) {
        self.webApiRequest = webApiRequest
    }
    
    func kittyDescription(completionHandler: @escaping (KittyDescription?, APIError?) -> Void) {
        let descriptionUrl = Constants.kittyDescriptionURL.rawValue
        guard let url = URL(string: descriptionUrl) else {
            completionHandler(nil, .errorURL)
            return
        }
                
        webApiRequest.Request(url, KittyDescription.self) { parsedResponse, error in
            if let _ = error {
                completionHandler(nil, .errorResponse)
            }
            else {
                completionHandler(parsedResponse, nil)
            }
        }
    }
    
    func kittyImage(completionHandler: @escaping (Data?, APIError?) -> Void) {
        let r1 = Int.random(in: 100..<999)
        let h1 = Int.random(in: 100..<999)
        let imageURL = Constants.kittyImageURL.rawValue + "\(r1)/\(h1)"
        guard let url = URL(string: imageURL) else {
            completionHandler(nil, .errorURL)
            return
        }
        webApiRequest.DownloadRequest(url) { parsedResponse, error in
            if let _ = error {
                completionHandler(nil, .errorResponse)
            }
            else {
                completionHandler(parsedResponse, nil)
            }
        }
    }
}


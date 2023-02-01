//
//  KittyViewModel.swift
//  KittyFacts
//
//  Created by Swapnil Ratnaparkhi on 1/31/23.
//

import Foundation
import UIKit

protocol ResponseDelegate: AnyObject {
    func updateUI()
}

class KittyViewModel {
    var description: KittyDescription?
    var image: UIImage?
    var kittyManager: KittyManagerDelegate
    weak var delegate: ResponseDelegate?

    init(_ kittyManager: KittyManagerDelegate = KittyNetworkManager()) {
        self.kittyManager = kittyManager
    }
    
    func fetchKittyDetails(_ completion: (() -> Void)? = nil) {
        let group = DispatchGroup()
        group.enter()
        kittyManager.kittyDescription { [weak self] (score, error) in
            if let score = score {
                self?.description = score
            }
            group.leave()
        }
        
        group.enter()
        kittyManager.kittyImage { [weak self] (result, error) in
            if let imgData = result {
                self?.image = UIImage(data: imgData)
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            self.delegate?.updateUI()
            
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                if let completion = completion {
                    completion()
                }
            }
        })
    }
    
}

//
//  ViewController.swift
//  KittyFacts
//
//  Created by Swapnil Ratnaparkhi on 1/31/23.
//

import UIKit

class ViewController: UIViewController, ResponseDelegate {

    @IBOutlet weak var kittyDescription: UILabel!
    @IBOutlet weak var kittyImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var kittyVM: KittyViewModel = {
        let kittyVM = KittyViewModel()
        kittyVM.delegate = self
        return kittyVM
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        self.activityIndicator.hidesWhenStopped = true
        
        hideView(hide: true)
        loadData()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        loadData()
    }
    
    private func loadData() {
        activityIndicator.startAnimating()
        kittyVM.fetchKittyDetails()
    }
    
    private func hideView(hide: Bool) {
        self.kittyDescription.isHidden = hide
        self.kittyImage.isHidden = hide
    }

    func updateUI() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.hideView(hide: false)
            self.kittyDescription.text = self.kittyVM.description?.data.first
            self.kittyImage.image = self.kittyVM.image
        }
    }
}


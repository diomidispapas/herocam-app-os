//
//  LoadingViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 28/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

final class LoadingViewController: UIViewController, Injectable {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate weak var circlesImageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView! {
        didSet {
            if let unwrappedBackgroundImage = self.backgroundImage {
                self.backgroundImageView.image = unwrappedBackgroundImage
            }
        }
    }
    
    // MARK: Injected Properties
    
    fileprivate(set) var backgroundImage: UIImage!
    
    // MARK: Injectable
    
    func inject(_ backgroundImage: UIImage) {
        self.backgroundImage = backgroundImage
    }
    
    func assertDependencies() {
        assert(self.backgroundImage != nil)
    }
    
    //MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.circlesImageView.rotate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.circlesImageView.stopRotating()
    }
    
    deinit {
        Log.ln("\(type(of: self)) has been deallocated")/
    }
}

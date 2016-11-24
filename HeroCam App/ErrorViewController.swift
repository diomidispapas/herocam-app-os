//
//  ErrorViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

/// ```UIViewController``` subclass that is responsible for providing an error output to the user
class ErrorViewController: UIViewController, Injectable, NavigationTitlePresentable {
    
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.text = self.errorOptions.message
        }
    }
    @IBOutlet weak var errorImageView: UIImageView! {
        didSet {
            errorImageView.isHidden = (self.errorOptions.image == nil)
        }
    }
    @IBOutlet weak var actionButton: UIButton! {
        didSet {
            actionButton.setTitle(self.errorOptions.actionTitle, for: UIControlState())
        }
    }
    
    //MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assertDependencies()
        self.setupNavigationTitleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Injected Properties
    
    fileprivate(set) var errorOptions: ErrorOptions!
    
    // MARK: Injectable
    
    func inject(_ errorOptions: ErrorOptions) {
        self.errorOptions = errorOptions
    }
    
    func assertDependencies() {
        assert(self.errorOptions != nil)
    }
    
    //MARK: Actions
    
    @IBAction func actionButtonTouchedUpInside(_ sender: AnyObject) {
        if let action = self.errorOptions.action {
            action()
        }
    }
}

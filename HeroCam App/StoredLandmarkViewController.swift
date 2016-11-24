//
//  StoredLandmarkViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 10/3/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

final class StoredLandmarkViewController: UIViewController, Injectable, NavigationTitlePresentable, FeedbackProvidable {
    // MARK: Public Properties
    /// Landmark that is used in order to present information into the screen. It automatically setup the views
    fileprivate(set) var landmark: LandmarkType!
    
    //MARK: Injectable
    typealias T = LandmarkType
    func inject(_ landmark: LandmarkType) {
        self.landmark = landmark
    }
    
    func assertDependencies() {
        assert(landmark != nil)
    }
    
    // MARK: Private Properties
    /// TALandmarkDescriptionView instance that is set up using the 'landmark: TALandmark' instance
    fileprivate var landmarkView: TALandmarkDescriptionView? {
        didSet {
            self.landmarkView?.delegate = self
            self.landmarkView!.titleLabel.text = landmark.title
            if let wikipediaSnippet = landmark?.wikipediaSnippet {
                self.landmarkView!.descriptionLabel.text = wikipediaSnippet
            }
            if let imageURLString = landmark?.wikipediaThumbnailURLString {
                self.landmarkView?.imageURL = URL(string: imageURLString)!
            }
        }
    }
    
    // MARK: Outlets
    /// The scroll view
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    /// Computed outlet property that contains an 'TALandmarkDescriptionView' instance
    @IBOutlet fileprivate weak var landmarkContainerView: UIView! {
        didSet {
            landmarkView = TALandmarkDescriptionView.fromNib()
            landmarkView!.frame = landmarkContainerView!.frame
            landmarkContainerView.addSubview(landmarkView!)
            landmarkContainerView.translatesAutoresizingMaskIntoConstraints = false
            landmarkContainerView.bottomAnchor.constraint(equalTo: (landmarkView?.bottomAnchor)!,constant: 0).isActive=true
            landmarkContainerView.topAnchor.constraint(equalTo: (landmarkView?.topAnchor)!,constant: 0).isActive=true
            landmarkContainerView.leadingAnchor.constraint(equalTo: (landmarkView?.leadingAnchor)!,constant: 0).isActive=true
            landmarkContainerView.trailingAnchor.constraint(equalTo: (landmarkView?.trailingAnchor)!,constant: 0).isActive=true
        }
    }
    
    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationTitleView()
        self.setupLeftBarButtonItem()
    }
    
    func setupLeftBarButtonItem() {
        if Settings.persisatanceOverride() {
            let deleteButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(StoredLandmarkViewController.deleteBarButtonTouchedUpInside(_:)))
            deleteButton.tintColor = ColorPalette.white
            self.navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    deinit {
        Log.ln("\(type(of: self)) has been deallocated")/
    }
}

extension StoredLandmarkViewController : TALandmarkDescriptionViewDelegate, SharePopoverRenderer, BrowserPresentable, SFSafariViewControllerDelegate {
    // MARK: TALandmarkDescriptionViewDelegate
    func viewOnWikipediaButtonTouchedUpInside() {
        self.presentBrowser(with: URL(string: landmark.wikipediaURLString)!)
    }
    
    func shareButtonTouchedUpInside() {
        // TODO: Implement the sharing option for the offline feature
    }
}

extension StoredLandmarkViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case .cancelled:
            Log.ln("Mail cancelled")/
        case .saved:
            Log.ln("Mail saved")/
        case .sent:
            Log.ln("Mail sent")/
        case .failed:
            if let error = error {
                Log.error(error as NSError)/
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension StoredLandmarkViewController {
    @objc func deleteBarButtonTouchedUpInside(_ sender: AnyObject) {
        let persistanceRepository = PersistedLandmarkRepository(storage: Storage.shared)
        let outcome = persistanceRepository.delete(entity: self.landmark as! PersistedLandmark)
        if (outcome == .saved) {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
}

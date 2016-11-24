//
//  LandmarkViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

final class LandmarkViewController: UIViewController, Injectable, NavigationTitlePresentable, FeedbackProvidable {
    
    typealias LandmarkViewControllerDismissalBlock = (Void) -> Void
    var dismissalBlock: LandmarkViewControllerDismissalBlock?
    
    // MARK: Public Properties
    
    /// Landmark that is used in order to present information into the screen. It automatically setup the views
    fileprivate(set) var landmark: Landmark!
    fileprivate(set) var query: Query!
    
    //MARK: Injectable
    /// Injected tuple for the landmark and the query
    typealias T = (Query, Landmark)
    func inject(_ box: (Query, Landmark)) {
        self.query = box.0
        self.landmark = box.1
    }
    
    func assertDependencies() {
        assert(query != nil)
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
            if let imageURL = landmark?.wikipediaThumbnail {
                self.landmarkView?.imageURL = imageURL
            }
        }
    }
    
    fileprivate var wrongLandmarkView: TAWrongLandmarkView? {
        didSet {
            self.wrongLandmarkView?.delegate = self
            self.wrongLandmarkView?.image = query.image
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
    
    /// Computed outlet property that contains an 'TAWrongLandmarkView' instance
    @IBOutlet fileprivate weak var wrongLandmarkContainerView: UIView! {
        didSet {
            wrongLandmarkView = TAWrongLandmarkView.fromNib()
            wrongLandmarkView!.frame = wrongLandmarkContainerView!.frame
            wrongLandmarkContainerView.addSubview(wrongLandmarkView!)
            wrongLandmarkContainerView.translatesAutoresizingMaskIntoConstraints = false
            wrongLandmarkContainerView.bottomAnchor.constraint(equalTo: (wrongLandmarkView?.bottomAnchor)!,constant: 0).isActive=true
            wrongLandmarkContainerView.topAnchor.constraint(equalTo: (wrongLandmarkView?.topAnchor)!,constant: 0).isActive=true
            wrongLandmarkContainerView.leadingAnchor.constraint(equalTo: (wrongLandmarkView?.leadingAnchor)!,constant: 0).isActive=true
            wrongLandmarkContainerView.trailingAnchor.constraint(equalTo: (wrongLandmarkView?.trailingAnchor)!,constant: 0).isActive=true
        }
    }
    
    // MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assertDependencies()
        self.setupNavigationTitleView()
        self.setupLeftBarButtonItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissalBlock?()
    }
    
    func setupLeftBarButtonItem() {
        if Settings.persisatanceOverride() {
            let storeButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(LandmarkViewController.storeBarButtonTouchedUpInside(_:)))
            storeButton.tintColor = ColorPalette.white
            self.navigationItem.rightBarButtonItem = storeButton
        }
    }
    
    deinit {
        Log.ln("\(type(of: self)) has been deallocated")/
    }
}

extension LandmarkViewController : TALandmarkDescriptionViewDelegate, TAWrongLandmarkViewDelegate, SharePopoverRenderer, BrowserPresentable, SFSafariViewControllerDelegate {
    
    // MARK: TALandmarkDescriptionViewDelegate
    
    func viewOnWikipediaButtonTouchedUpInside() {
        if let wikipediaURL = self.landmark?.wikipediaURL {
            self.presentBrowser(with: wikipediaURL)
        }
    }
    
    func shareButtonTouchedUpInside() {
        self.display(shareSheet: Sharing(title: landmark.title, subtitle: landmark.wikipediaSnippet, image: query.image, wikipediaURL: landmark.wikipediaURL))
    }
    
    // MARK: TAWrongLandmarkViewDelegate
    
    func askYourFriendsForHelpButtonTouchedUpInside() {
        self.display(shareSheet: Sharing(title: landmark.title, subtitle: landmark.wikipediaSnippet, image: query.image, wikipediaURL: landmark.wikipediaURL))
    }
    
    func giveUsABetterAnswerButtonTouchedUpInside() {
        self.presentFeedback(with: FeedbackOptions(title: "Feedback", body: "Feature request or bug report?"))
    }
}

extension LandmarkViewController: MFMailComposeViewControllerDelegate {
    
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

//MARK: Persistance functionallity
extension LandmarkViewController {
    
    @objc func storeBarButtonTouchedUpInside(_ sender: AnyObject) {
        self.persistLandmark(landmark)
    }
    
    func persistLandmark(_ landmark: Landmark) {
        let persistanceRepository = PersistedLandmarkRepository(storage: Storage.shared)
        let outcome = persistanceRepository.store(entity: landmark)
        if outcome == .saved {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

//
//  InitialViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import ServiceKit

final class InitialViewController: UIViewController, NavigationTitlePresentable, CameraViewControllerDelegate, ErrorRenderer, ContaningViewController {
    
    /// The container view that contains other view controllers depending on the 'state' of the view controller
    @IBOutlet weak var containerView: UIView!
    
    fileprivate(set) var viewModel: InitialViewModel<Service<Landmark>>!
    
    /// Property for storing a reference to the current active view controller. When the value is charged it invokes two methods for removing the old and adding the new child view controller
    var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    //MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationTitleView()
        self.viewModel = InitialViewModel(service: Service())
        self.setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.state <- .waitingForImage
    }
    
    //MARK: Observers
    
    fileprivate func setupObservers() {
        self.viewModel.state.didChange.addHandler(self, handler: InitialViewController.stateDidChange)
    }
    
    fileprivate func stateDidChange(_ oldValue: InitialViewControllerState, newValue: InitialViewControllerState) {
        self.userInterfaceForState(newValue)
        Log.ln("🤖 \(type(of: newValue)) changed: \(newValue)")/
    }
    
    //MARK: UI
    
    fileprivate func userInterfaceForState(_ state: InitialViewControllerState) {
        DispatchQueue.main.async(execute: { () -> Void in
            switch state {
            case .initialized: break
            case .waitingForImage:
                self.setCameraViewControllerAsActiveVC()
                break
                
            case .imageReady(_):
                self.viewModel.getLandmarkDetails { (outcome) -> Void in
                    switch outcome {
                    case .success(let landmark):
                        Log.obj(landmark)/
                        
                    case .failure( _):
                        Log.ln("Present error")/
                    }
                }
                break
                
            case .waittingForResponse(let query):
                self.setLoadingViewControllerAsActiveVC(with: query.image)
                break
                
            case .presentingDescription((let query, let landmark)):
                // Set the view to the camera
                self.pushLandmarkViewController(with:query, landmark: landmark as! Landmark)
                break
                
            case .presentingError:
                // Set the view to the camera
                let errorOptions = ErrorOptions(message: "Hmm... It seems there is no landmark in your photo", actionTitle: "TRY AGAIN", action: { [unowned self] in
                    _ = self.navigationController?.popViewController(animated: true)
                    } , image: UIImage(named: "nolandmark_pic"))
                self.presentError(with: errorOptions, presentationOption: .push)
                break
            }
        })
    }
    
    //MARK: InitialViewController Delegate
    func didCapturePicture(_ image: UIImage) {
        self.viewModel.query = Query(image: image)
    }
    
    func failedToAccessCamera() {
        if (Settings.mockCameraAccessOverride()) {
            self.viewModel.query = Query(image: UIImage(named: "Acropolis")!)
            // Reset the mock camera access
            Settings.registerMockCameraAccessOverride(false)
        } else {
            let error = ErrorOptions(message: "Hmm... It seems there is no camera access", actionTitle: "SETTINGS" , action: {
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }
            })
            self.presentError(with: error, presentationOption: .embed)
        }
    }
    
    //MARK: Private
    
    /** Helper method for removing the old child view controller */
    fileprivate func removeInactiveViewController(_ inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            inActiveVC.willMove(toParentViewController: nil)
            inActiveVC.view.removeFromSuperview()
            inActiveVC.removeFromParentViewController()
        }
    }
    
    /** Helper method for updating the active view controller */
    fileprivate func updateActiveViewController() {
        if let activeVC = activeViewController {
            addChildViewController(activeVC)
            activeVC.view.frame = containerView.bounds
            containerView.addSubview(activeVC.view)
            activeVC.didMove(toParentViewController: self)
        }
    }
    
    fileprivate func setCameraViewControllerAsActiveVC() {
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: CameraViewController.storyboardIdentifier) as? CameraViewController
        initialViewController?.delegate = self
        self.activeViewController = initialViewController
    }
    
    fileprivate func setLoadingViewControllerAsActiveVC(with image: UIImage) {
        let loadingViewController = self.storyboard!.instantiateViewController(withIdentifier: LoadingViewController.storyboardIdentifier) as? LoadingViewController
        loadingViewController?.inject(image)
        self.activeViewController = loadingViewController
    }
    
    func pushLandmarkViewController(with query:Query, landmark: Landmark) {
        let landmarkViewController = self.storyboard!.instantiateViewController(withIdentifier: LandmarkViewController.storyboardIdentifier) as? LandmarkViewController
        landmarkViewController?.inject((query, landmark))
        self.navigationController?.pushViewController(landmarkViewController!, animated: true)
    }
}

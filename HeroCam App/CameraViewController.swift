//
//  CameraViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

/// Data structure for keeping the state of the TACameraViewController
enum CameraViewControllerState: String {
    case Initialized, PresentingCamera, HiddenCamera, ImageCaptured
}

protocol CameraViewControllerDelegate: class {
    /// Delegate method that is invoked when the user presses the capture picture button
    func didCapturePicture(_ image: UIImage)
    
    /// Delegate method that is invoked when the user denies camera access
    func failedToAccessCamera()
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TACameraOverlayViewDelegate {
    
    //MARK: Properties
    
    fileprivate lazy var imagePicker: UIImagePickerController = {
        let _imagePicker = UIImagePickerController()
        _imagePicker.delegate = self
        _imagePicker.sourceType = .camera
        _imagePicker.cameraCaptureMode = .photo
        _imagePicker.cameraDevice = .rear
        _imagePicker.showsCameraControls = false
        _imagePicker.isNavigationBarHidden = false
        _imagePicker.isToolbarHidden = true
        _imagePicker.view.backgroundColor = UIColor.clear
        
        // transform preview to full screen
        let screenSize = UIScreen.main.bounds.size
        
        // iOS is going to calculate a size which constrains the 4:3 aspect ratio
        // to the screen size. We're basically mimicking that here to determine
        // what size the system will likely display the image at on screen.
        // NOTE: screenSize.width may seem odd in this calculation - but, remember,
        // the devices only take 4:3 images when they are oriented *sideways*.
        let cameraAspectRatio = 4.0 / 3.0;
        let imageWidth = floor(Double(screenSize.width) * cameraAspectRatio);
        let scale = ceil((Double(screenSize.height) / imageWidth) * 10.0) / 10.0;
        _imagePicker.cameraViewTransform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale));
        _imagePicker.cameraOverlayView = self.cameraOverlayView
        return _imagePicker
    }()
    
    
    /// State of the ```CameraViewController```. The view controller will present according to its state
    var state: Observable<CameraViewControllerState> = Observable(.Initialized)
    
    /// Overlay view for the imagePicker
    var cameraOverlayView: TACameraOverlayView {
        get {
            let cameraOverlay: TACameraOverlayView = TACameraOverlayView.fromNib()
            cameraOverlay.frame = self.view.bounds
            cameraOverlay.delegate = self
            cameraOverlay.hidesBottomBar = UIScreen.main.bounds.height / UIScreen.main.bounds.width < 1.6
            return cameraOverlay
        }
    }
    
    weak var delegate:CameraViewControllerDelegate?
    
    //MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.state <- .PresentingCamera
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.state <- .HiddenCamera
    }
    
    deinit {
        Log.ln("\(type(of: self)) has been deallocated")/
    }
    
    //MARK: Observers
    
    fileprivate func setupObservers() {
        self.state.didChange.addHandler(self, handler: CameraViewController.stateDidChange)
    }
    
    fileprivate func stateDidChange(_ oldValue: CameraViewControllerState, newValue: CameraViewControllerState) {
        self.userInterfaceForState(newValue)
        Log.ln("🤖 \(type(of: newValue)) state changed: \(newValue)")/
    }
    
    //MARK: UI
    
    fileprivate func userInterfaceForState(_ state: CameraViewControllerState) {
        DispatchQueue.main.async(execute: { () -> Void in
            switch state {
            case .Initialized:
                break
                
            case .PresentingCamera:
                self.presentImagePicker()
                break
                
            case .HiddenCamera:
                self.hideImagePicker()
                break
                
            case .ImageCaptured:
                self.hideImagePicker()
                break
            }
        })
    }
    
    //MARK: Private / Helper
    
    /// Helper method for presenting the camera image picker
    fileprivate func presentImagePicker() {
        if (Permissions.camera.hasPermission && !Settings.noCameraAccessOverride() && !Platform.isSimulator) {
            //iPad hack (this is in order to pass the review process)
            let scale = UIScreen.main.bounds.height / UIScreen.main.bounds.width
            self.view.addSubview(self.imagePicker.view)
            self.imagePicker.view.translatesAutoresizingMaskIntoConstraints = false
            self.imagePicker.view.bottomAnchor.constraint(equalTo: (self.view?.bottomAnchor)!,constant: 0).isActive=true
            self.imagePicker.view.topAnchor.constraint(equalTo: (self.view?.topAnchor)!,constant: scale < 1.6
                ? -25 : 60).isActive=true
            self.imagePicker.view.leadingAnchor.constraint(equalTo: (self.view?.leadingAnchor)!,constant: 0).isActive=true
            self.imagePicker.view.trailingAnchor.constraint(equalTo: (self.view?.trailingAnchor)!,constant: 0).isActive=true
        } else {
            self.delegate?.failedToAccessCamera()
        }
    }
    
    fileprivate func hideImagePicker() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera) && !Settings.noCameraAccessOverride()) {
            self.imagePicker.removeFromParentViewController()
        }
    }
    
    //MARK: UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let reducedImage = image.resize(0.5)
        self.delegate!.didCapturePicture(reducedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: .none)
    }
    
    // MARK: TACameraOverlayViewDelegate
    
    func takePhotoButtonTouchedUpInside() {
        // programatically initiates still image capture. ignored if image capture is in-flight.
        // clients can initiate additional captures after receiving -imagePickerController:didFinishPickingMediaWithInfo: delegate callback
        self.imagePicker.takePicture()
    }
}

//
//  InitialViewModel.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 28/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import ServiceKit

enum InitialViewModelError: Error {
    case error(String)
}

enum InitialViewControllerState {
    case initialized, waitingForImage, imageReady(Query), waittingForResponse(Query), presentingDescription((Query, Any)), presentingError
    
    var description: String {
        switch self {
        default: return String(describing: self)
        }
    }
}

struct InitialViewModel<T> where T:Postable, T.U: ResponseObjectSerializable {
    
    //MARK: Properties
    
    /// Image to get description
    var query: Query? {
        didSet {
            if (Settings.sendFakeImageOverride()) {
                query = Query(image: UIImage(named: "white-house")!)
            }
            self.state <- .imageReady(query!)
        }
    }
    
    /// State of the View Controller. The view controller will present according to its state
    var state: Observable<InitialViewControllerState> = Observable(.initialized)
    
    /// Landmark to keep the result instance. Landmark changes the state as well
    var landmark: T.U? {
        willSet {
            // Check that the landmark contains real information.
            // Otherwise change the state to error state
            if let newValue = newValue {
                self.state <- .presentingDescription((self.query! ,newValue))
            } else {
                self.state <- .presentingError
            }
        }
    }
    
    var service: T
    
    //MARK: Initialization
    
    init(service: T) {
        self.service = service;
    }
    
    //MARK: Service Requests
    
    mutating func getLandmarkDetails(_ callback: @escaping (Failable<T.U, InitialViewModelError>) -> Void) {
        
        guard let query = query else {
            callback(.failure(.error("The image was not correct")))
            return
        }
        
        self.state <- .waittingForResponse(query)
        var copy = self
        let completion: (Failable<T.U, NetworkError >) -> Void = { (outcome: Failable<T.U, NetworkError>) in
            switch outcome {
            case .success(let landmark):
                copy.landmark = landmark
                callback(.success(landmark))
                
            case .failure( _):
                copy.landmark = nil
                callback(.failure(.error("The image was not correct")))
            }
        }
        self = copy
        
        if (Settings.responseMockingOverride()) {
            let fakeService = FakeService<T.U>(responseFilepath: "landmark-fake-response")
            fakeService.post(PostPhotoRequest(image: query.image), completionHandler: completion)
        } else {
            service.post(PostPhotoRequest(image: query.image), completionHandler: completion)
        }
    }
}

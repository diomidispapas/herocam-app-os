//
//  CameraPermission.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 10/6/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import AVFoundation

typealias Result = (_ success: Bool) -> Void

protocol Permissionable {
    var hasPermission: Bool { get }
    func request(_ sender: UIViewController, _ block: Result?)
}

/// Enum that contains all the persmissions that the application will require. //TODO: use ```switch``` statement in case we need more permissions
enum Permissions: Permissionable {
    case camera
    
    var hasPermission: Bool {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        return (status == .authorized) ? true : false
    }
    
    func request(_ sender: UIViewController, _ block: Result?) {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,
                                                  completionHandler: { (granted:Bool) -> Void in
                                                    granted ? Log.ln("📷 Camera persmission granted")/ : Log.ln("📷 Camera persmission declined")/
                                                    if let block = block {
                                                        block(granted)
                                                    }
        })
    }

}

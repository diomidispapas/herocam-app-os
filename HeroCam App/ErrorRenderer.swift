//
//  ErrorRenderer.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

enum ErrorRendererPresentationOptions {
    case present, push, embed
}

protocol ErrorRenderer: class {
    func presentError(with options:ErrorOptions, presentationOption: ErrorRendererPresentationOptions)
}

extension ErrorRenderer where Self: UIViewController, Self: ContaningViewController {
    func presentError(with options:ErrorOptions, presentationOption: ErrorRendererPresentationOptions) {
        let error = errorViewController()
        error?.inject(options)
        switch presentationOption {
        case .present:
            self.present(error!, animated: true, completion: nil)
            break
            
        case .push:
            self.navigationController?.pushViewController(error!, animated: true)
            break
            
        case .embed:
            self.activeViewController = error
            break
            
        }
    }
    
    fileprivate func errorViewController() -> ErrorViewController? {
        return self.storyboard!.instantiateViewController(withIdentifier: ErrorViewController.storyboardIdentifier) as? ErrorViewController
    }
}

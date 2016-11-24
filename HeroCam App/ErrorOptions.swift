//
//  ErrorOptions.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

typealias ErrorOptionsAction = (Void) -> Void

struct ErrorOptions {
    let message: String
    let messageColor: UIColor
    var image: UIImage?
    let actionTitle: String
    let actionTitleColor: UIColor
    var action: ErrorOptionsAction?

    init(message: String = "Error!", messageColor: UIColor = ColorPalette.blue.medium, actionTitle: String = "Action", actionTitleColor: UIColor = ColorPalette.blue.medium, action: ErrorOptionsAction? = nil, image: UIImage? = nil) {
        self.message = message
        self.messageColor = messageColor
        self.actionTitle = actionTitle
        self.actionTitleColor = actionTitleColor
        self.action = action
        self.image = image
    }
}

//
//  FeedbackProvidable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/22/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit
import MessageUI

struct FeedbackOptions {
    let title: String
    let body: String
    let recipient: String
    init(title: String, body: String, recipient: String = "herocam.app@gmail.com") {
        self.title = title
        self.body = body
        self.recipient = recipient
    }
}

protocol FeedbackProvidable {
    func presentFeedback(with options: FeedbackOptions)
}

extension FeedbackProvidable where Self: UIViewController, Self: MFMailComposeViewControllerDelegate {

    func presentFeedback(with options: FeedbackOptions) {
        if MFMailComposeViewController.canSendMail() {
            let emailTitle = options.title
            let messageBody = options.body
            let toRecipents = [options.recipient]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            self.present(mc, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "An error occured", message: "Unfortunetly we were not able to send your feedback", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}

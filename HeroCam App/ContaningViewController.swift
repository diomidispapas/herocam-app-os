//
//  ContaningViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

protocol ContaningViewController: class {
    var activeViewController: UIViewController? { get set }
}

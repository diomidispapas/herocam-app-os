//
//  NavigationTitle.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 18/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

protocol NavigationTitlePresentable {
    func setupNavigationTitleView()
}

extension NavigationTitlePresentable where Self: UIViewController {
    func setupNavigationTitleView() {
        self.navigationController?.navigationBar.barTintColor = ColorPalette.blue.medium
        self.navigationController?.navigationBar.tintColor = ColorPalette.blue.medium
        self.navigationController?.navigationBar.hideBottomHairline()
        let navigationTitleView: TANavigationTitleView = TANavigationTitleView.fromNib()
        navigationTitleView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        navigationItem.titleView = navigationTitleView
    }
}

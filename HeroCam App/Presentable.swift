//
//  Presentable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

//MARK: Title Presentable
protocol TitlePresentable {
    var title: String { get }
    var titleColor: UIColor { get }
    var highlightedTitleColor: UIColor { get }
    var titleFont: UIFont { get }
}
extension TitlePresentable {
    var title: String { return "" }
    var titleColor: UIColor { return ColorPalette.blue.medium }
    var highlightedTitleColor: UIColor { return ColorPalette.blue.fadedMedium }
    var titleFont: UIFont { return FontBook.Light.of(.Headline) }
}

//MARK: Subtitle Presentable
protocol SubtitlePresentable {
    var subtitle: String { get }
    var subtitleColor: UIColor { get }
    var subtitleFont: UIFont { get }
}
extension SubtitlePresentable {
    var subtitle: String { return "" }
    var subtitleColor: UIColor { return ColorPalette.gray.light }
    var subtitleFont: UIFont { return UIFont.systemFont(ofSize: 15.0) }
}

//MARK: Separator Presentable
protocol SeparatorPresentable {
    var separatorVisibility: Bool { get }
    var separatorColor: UIColor { get }
}
extension SeparatorPresentable {
    var separatorVisibility: Bool { return true }
    var separatorColor: UIColor { return ColorPalette.blue.medium }
}

//MARK: Separator Presentable
protocol SwitcherPresentable {
    var switcherValue: Bool { get }
    var switcherColor: UIColor { get }
    var switcherValueDidChange: ((Bool) -> Void)? { get }
}
extension SwitcherPresentable {
    var switcherValue: Bool { return true }
    var switcherColor: UIColor { return ColorPalette.blue.medium }
}

//MARK: Image Presentable
protocol ImagePresentable {
    var imageName: String { get }
}

//MARK: Remote Image Presentable
//TODO: Probably remove as we do not care whether the image is remote or not on the UI side
protocol RemoteImagePresentable {
    var imageURL: String { get }
    var placeholderImageName: String { get }
}
extension RemoteImagePresentable {
    var placeholderImageName: String { return "stack_placeholder" }
}

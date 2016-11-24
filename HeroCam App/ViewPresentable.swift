//
//  ViewPresentable.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 29/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

//MARK: TitleLabel Presentable
protocol TitleLabelPresentable {
    var titleLabel: UILabel! { get set }
    func setTitle(_ title: String?)
}
extension TitleLabelPresentable {
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
}

//MARK: SubtitleLabel Presentable
protocol SubtitleLabelPresentable {
    var subtitleLabel: UILabel! { get set }
    func setSubtitle(_ title: String?)
}
extension SubtitleLabelPresentable {
    func setSubtitle(_ title: String?) {
        subtitleLabel.text = title
    }
}

//MARK: SubtitleLabel Presentable
typealias SwitcherViewPresentableClosure = (Bool) -> Void
protocol SwitcherViewPresentable {
    var switcher: UISwitch! { get set }
    func onSwitchTogleOn(_ on: Bool)
    var switcherValueDidChange: SwitcherViewPresentableClosure? { get set }
}
extension SwitcherViewPresentable {
    func onSwitchTogleOn(_ on: Bool) {
        switcher.isOn = on
    }
}

//MARK: SeparatorView Presentable
protocol SeparatorViewPresentable {
    var separatorView: UIView! { get set }
}


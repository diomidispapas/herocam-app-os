//
//  DebugTableViewCell.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 28/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

// Using protocol composition we are able to compose the data source of the Cell using smaller components. Each of these offers a default implementation. The idea is all the cells that contains a 'Title' will basically inherit the default implemntation of the TitlePresentable.
typealias DebugTableViewCellDataSource = TitlePresentable & SubtitlePresentable & SwitcherPresentable & SeparatorPresentable

struct DebugTableViewCellModel: DebugTableViewCellDataSource {
    var title: String
    var subtitle: String
    var switcherValue: Bool
    var separatorVisibility: Bool
    var switcherValueDidChange: ((Bool) -> Void)?
}

class DebugTableViewCell: UITableViewCell, TitleLabelPresentable, SubtitleLabelPresentable, SwitcherViewPresentable {
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var separatorView: UIView!
    
    var switcherValueDidChange: SwitcherViewPresentableClosure?
    fileprivate var dataSource: DebugTableViewCellModel?
    
    func configure(with dataSource: DebugTableViewCellDataSource) {
        self.titleLabel.text = dataSource.title
        self.subtitleLabel.text = dataSource.subtitle
        self.switcher.setOn(dataSource.switcherValue, animated: true)
        self.separatorView.isHidden = dataSource.separatorVisibility
        self.switcherValueDidChange = dataSource.switcherValueDidChange
    }
    
    // MARK: Actions
    
    @IBAction func switcherValueChanged(_ sender: UISwitch) {
        if let switcherValueChangeCallback = self.switcherValueDidChange {
            switcherValueChangeCallback(sender.isOn)
        }
    }
}

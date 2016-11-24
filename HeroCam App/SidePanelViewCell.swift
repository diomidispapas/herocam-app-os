//
//  SidePanelViewCell.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 24/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

// Using protocol composition we are able to compose the data source of the Cell using smaller components. Each of these offers a default implementation. The idea is all the cells that contains a 'Title' will basically inherit the default implemntation of the TitlePresentable.
typealias SidePanelViewCellDataSource = TitlePresentable & SeparatorPresentable

struct SidePanelViewCellModel: SidePanelViewCellDataSource {
    var title: String
    var separatorVisibility: Bool
    var separatorColor: UIColor
}

/// Table view cell of the ````SideMenuTableViewController```
class SidePanelViewCell: UITableViewCell, TitleLabelPresentable, SeparatorViewPresentable {
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    fileprivate var dataSource: SidePanelViewCellDataSource?
    
    //MARK: Public
    func configure(withDataSource dataSource: SidePanelViewCellDataSource) {
        self.dataSource = dataSource
        titleLabel.text = dataSource.title
        titleLabel.textColor = dataSource.titleColor
        separatorView.isHidden = !dataSource.separatorVisibility
        separatorView.backgroundColor = dataSource.separatorColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(isHighlighted, animated: animated)
        self.titleLabel.textColor = selected ? dataSource?.highlightedTitleColor : dataSource?.titleColor
    }
}

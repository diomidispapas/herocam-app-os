//
//  SidePanelViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/23/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

enum SidePanelOption: String {
    case Home = "Home"
    case Saved = "Saved"
    case Help = "Help"
    case RateUs = "Rate Us"
    case ContactUs = "Contact Us"
    case About = "About"
    case Debug = "Debug"
}

protocol SidePanelViewControllerDelegate: class {
    func itemSelected(_ item: SidePanelOption)
}

class SidePanelViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            if let versionNumber = Bundle.main.releaseVersionNumber,
                let buildNumber = Bundle.main.buildVersionNumber {
                self.versionLabel.text = "Version \(versionNumber)(\(buildNumber)) "
            }
            else {
                self.versionLabel.isHidden = true
            }
        }
    }
    
    // MARK: Properties
    
    /// Data Source of the table view. We cannot lazy instatiate the property as the content may change depending on the debug options.
    fileprivate var menuItems: [SidePanelOption] {
        get {
            #if DEBUG
                return Settings.persisatanceOverride() ? [.Home, .Saved, .Help, .RateUs, .ContactUs, .About, .Debug] : [.Home, .Help, .RateUs, .ContactUs, .About, .Debug]
            #elseif BETA
                return Settings.persisatanceOverride() ?[.Home, .Saved, .Help, .RateUs, .ContactUs, .About, .Debug] : [.Home, .Help, .RateUs, .ContactUs, .About, .Debug]
            #else
                return Settings.persisatanceOverride() ?[.Home, .Saved, .Help, .RateUs, .ContactUs, .About] : [.Home, .Help, .RateUs, .ContactUs, .About]
            #endif
        }
    }

    weak var delegate: SidePanelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // We need to reload the table view as the data source may change due to a debug option change
        tableView.reloadData()
    }
}

extension SidePanelViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SidePanelViewCell = tableView.dequeueReusable(indexPath)
        cell.configure(withDataSource: SidePanelViewCellModel(title: menuItems[indexPath.row].rawValue, separatorVisibility:presentsSeparator(indexPath), separatorColor: ColorPalette.blue.medium))
        return cell
    }
    
    // MARK: Private
    fileprivate func presentsSeparator(_ indexPath: IndexPath) -> Bool {
        return !(self.tableView.numberOfRows(inSection: 0) - 1 == indexPath.row)
    }
}

// MARK: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = menuItems[indexPath.row]
        delegate?.itemSelected(selectedItem)
    }
}


//
//  DebugViewController.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 28/09/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import UIKit

enum DebugViewControllerOption: String, CustomStringConvertible {
    case Onboarding = "Show Onboarding"
    case SendFakeImage = "Send Fake Image"
    case ResponseMocking = "Enable Fake Response"
    case NoCameraAccess = "No Camera Access"
    case MockCameraAccess = "Mock Camera Access"
    case Persistance = "Enable Persistance"
    
    var info: String {
        get {
            switch self {
            case .Onboarding: return "Presents the onboarding flow every time that the application opens"
            case .SendFakeImage: return "Sends an image of the 'White House' to the service instead of the captured photo"
            case .ResponseMocking: return "Mocks the server's response using a fake response that about the 'Buckinham Palace'"
            case .NoCameraAccess: return "Mocks the instance where the user's has not accepted the camera access permission"
            case .MockCameraAccess: return "This debug option is only used for iOS Simulation testing and it reset itself after one use"
            case .Persistance: return "Enables the local storing functionallity of a landmark. The functionality is available for Debug and Beta builds"
            }
        }
    }
    
    var value: Bool {
        get {
            switch self {
            case .Onboarding: return Settings.onboardingOverrideValue()
            case .SendFakeImage: return Settings.sendFakeImageOverride()
            case .ResponseMocking: return Settings.responseMockingOverride()
            case .NoCameraAccess: return Settings.noCameraAccessOverride()
            case .MockCameraAccess: return Settings.mockCameraAccessOverride()
            case .Persistance: return Settings.persisatanceOverride()
            }
        }
        set {
            switch self {
            case .Onboarding:
                Settings.registerOnboardingOverride(newValue)
            case .SendFakeImage:
                Settings.registerSendFakeImageOverride(newValue)
                if (newValue == true) {
                    Settings.registerResponseMockingOverride(false)
                }
            case .ResponseMocking:
                Settings.registerResponseMockingOverride(newValue)
                if (newValue == true) {
                    Settings.registerSendFakeImageOverride(false)
                }
            case .NoCameraAccess:
                Settings.registerNoCameraAccessOverride(newValue)
            case .MockCameraAccess:
                Settings.registerMockCameraAccessOverride(newValue)
            case .Persistance:
                Settings.registerPersisatanceOverride(newValue)
            }
        }
    }
    
    var description : String {
        switch self {
        default: return "\(type(of: self)): \(self.rawValue), value: \(self.value)"
        }
    }
}

final class DebugViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    // MARK: Properties
    fileprivate lazy var menuItems: [DebugViewControllerOption] = {
        #if DEBUG || BETA
            return Platform.isSimulator ? [.Onboarding, .SendFakeImage, .ResponseMocking, .MockCameraAccess, .Persistance] : [.Onboarding, .SendFakeImage, .ResponseMocking, .NoCameraAccess, .Persistance]
        #else
            return Platform.isSimulator ? [.Onboarding, .SendFakeImage, .ResponseMocking, .MockCameraAccess] : [.Onboarding, .SendFakeImage, .ResponseMocking, .NoCameraAccess]
        #endif
    }()
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DebugTableViewCell = tableView.dequeueReusable(indexPath)
        var debugOption = menuItems[indexPath.row]
        cell.configure(with: DebugTableViewCellModel(title: debugOption.rawValue, subtitle: debugOption.info, switcherValue: debugOption.value, separatorVisibility: self.isLastCell(for: indexPath), switcherValueDidChange: { [weak self] newValue in
            debugOption.value = newValue
            self?.tableView.reloadData()
            }))
        return cell
    }
    
    // MARK: Private
    fileprivate func isLastCell(for indexPath: IndexPath) -> Bool {
        return (self.tableView.numberOfRows(inSection: 0) - 1 == indexPath.row) ? true : false
    }
}

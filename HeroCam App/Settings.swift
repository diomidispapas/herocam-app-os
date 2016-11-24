//
//  Settings.swift
//  HeroCam App
//
//  Created by Diomidis Papas on 9/17/16.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

import Foundation

struct Settings {
    
    enum debug: String {
        case onboarding_debug, sendFakeImage, fakeResponse, fakeNoCameraAccess, fakeHasCameraAccess, persistance, service
        var key: String {
            switch self {
            default:
                return (String(describing: self))
            }
        }
    }
    
    enum defaults: String {
        case onboarding
        var key: String {
            switch self {
            default:
                return (String(describing: self))
            }
        }
    }
    
    struct Constants {
        static let AppStoreItemKey = "itms-apps://itunes.apple.com/app/id1078111204"
        static let SupportURLKey = "https://github.com/herocamapp"
    }
    
    static var Defaults: UserDefaults {
        get {
            return UserDefaults(suiteName: "com.diomidispapas.herocamapp")!
        }
    }
    
    // MARK: Onboarding
    static func registerOnboarding(_ hasSeen: Bool){
        Defaults[defaults.onboarding.key] = hasSeen
    }
    
    static func registerOnboardingOverride(_ enable: Bool){
        Defaults[debug.onboarding_debug.key] = enable
    }
    
    static func onboardingOverrideValue() -> Bool {
        return Defaults[debug.onboarding_debug.key].boolValue
    }
    
    static func onbardingValue() -> Bool {
        return Defaults[debug.onboarding_debug.key].boolValue ? !Defaults[debug.onboarding_debug.key].boolValue : Defaults[defaults.onboarding.key].boolValue
    }
    
    // MARK: Send Fake Image
    static func registerSendFakeImageOverride(_ fake: Bool){
        Defaults[debug.sendFakeImage.key] = fake
    }
    
    static func sendFakeImageOverride() -> Bool {
        return Defaults[debug.sendFakeImage.key].boolValue
    }
    
    // MARK: Response Mocking
    static func registerResponseMockingOverride(_ fake: Bool){
        Defaults[debug.fakeResponse.key] = fake
    }
    
    static func responseMockingOverride() -> Bool {
        return Defaults[debug.fakeResponse.key].boolValue
    }
    
    // MARK: No Camera Access
    static func registerNoCameraAccessOverride(_ fake: Bool){
        Defaults[debug.fakeNoCameraAccess.key] = fake
    }
    
    static func noCameraAccessOverride() -> Bool {
        return Defaults[debug.fakeNoCameraAccess.key].boolValue
    }
    
    // MARK: Mock Camera Access
    static func registerMockCameraAccessOverride(_ fake: Bool){
        Defaults[debug.fakeHasCameraAccess.key] = fake
    }
    
    static func mockCameraAccessOverride() -> Bool {
        return Defaults[debug.fakeHasCameraAccess.key].boolValue
    }
    
    // MARK: Persistance
    static func registerPersisatanceOverride(_ enable: Bool){
        Defaults[debug.persistance.key] = enable
    }
    
    static func persisatanceOverride() -> Bool {
        return Defaults[debug.persistance.key].boolValue
    }
}

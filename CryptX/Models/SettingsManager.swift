//
//  SettingsManager.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 20.07.2024.
//

import Foundation
import UIKit

class SettingsManager {
    static let shared = SettingsManager()
    
    fileprivate let userDefaults = UserDefaults.standard
    
    private init() {
        if userDefaults.object(forKey: "settingsArray") == nil {
            let numbers = (1...100).map { String($0) }
            let formattedNumbers = numbers.joined(separator: ",")
            CoinManager.shared.getAndSetCoins(ids: formattedNumbers, reset: true)
        }
        CoinManager.shared.startPeriodicUpdates()
    }
    
    // MARK: - User Defaults Variables
    
    var settingsArray: [CryptoCoin] {
        get {
            guard let data = userDefaults.data(forKey: "settingsArray") else { return [] }
            let decoder = JSONDecoder()
            return (try? decoder.decode([CryptoCoin].self, from: data)) ?? []
        }
        set {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newValue) {
                userDefaults.set(data, forKey: "settingsArray")
            }
        }
    }
    
    var displayedArray: [CryptoCoin] {
        get {
            guard let data = userDefaults.data(forKey: "displayedArray") else { return [] }
            let decoder = JSONDecoder()
            return (try? decoder.decode([CryptoCoin].self, from: data)) ?? []
        }
        set {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newValue) {
                userDefaults.set(data, forKey: "displayedArray")
                NotificationCenter.default.post(name: Notification.Name(AppConstants.NotificationName.displayedArrayChanged), object: nil)
            }
        }
    }
    
    var profilePhoto: UIImage {
        get {
            if let imageData = userDefaults.data(forKey: "profilePhoto") {
                return UIImage(data: imageData) ?? UIImage.avatarIcon
            }
            return UIImage.avatarIcon
        }
        set {
            if let imageData = newValue.pngData() {
                userDefaults.set(imageData, forKey: "profilePhoto")
            }
        }
    }
    
    var profileName: String {
        get {
            return userDefaults.object(forKey: "profileName") as? String ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: "profileName")
        }
    }
    
    var currentBalance: Double {
        get {
            return userDefaults.double(forKey: "currentBalance")
        }
        set {
            userDefaults.set(newValue, forKey: "currentBalance")
            NotificationCenter.default.post(name: Notification.Name(AppConstants.NotificationName.balanceUpdated), object: nil)
            DatabaseManager.shared.updateBalance(self.currentBalance)
        }
    }
    
    var numberOfCoins: [String: Double] {
        get {
            return userDefaults.dictionary(forKey: "numberOfCoins") as? [String: Double] ?? [:]
        }
        set {
            userDefaults.set(newValue, forKey: "numberOfCoins")
            NotificationCenter.default.post(name: Notification.Name(AppConstants.NotificationName.numberOfCoinsUpdated), object: nil)
            DatabaseManager.shared.updateNumberOfCoins(self.numberOfCoins)
        }
    }
    
    var currentEmail: String {
        get {
            return userDefaults.string(forKey: "currentEmail") ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: "currentEmail")
        }
    }
    
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLoggedInKey")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLoggedInKey")
        }
    }
    
    // MARK: - Methods
    
    func resetDefaults() {
        userDefaults.removeObject(forKey: "settingsArray")
        userDefaults.removeObject(forKey: "displayedArray")
        let numbers = (1...100).map { String($0) }
        let formattedNumbers = numbers.joined(separator: ",")
        CoinManager.shared.getAndSetCoins(ids: formattedNumbers, reset: true)
    }
    
    func resetAllSystem() {
        userDefaults.removeObject(forKey: "settingsArray")
        userDefaults.removeObject(forKey: "displayedArray")
        userDefaults.removeObject(forKey: "numberOfCoins")
        userDefaults.removeObject(forKey: "currentBalance")
        userDefaults.removeObject(forKey: "profileName")
        userDefaults.removeObject(forKey: "isLoggedInKey")
    }
    
    func isCoinDisplayed(_ coin: CryptoCoin) -> Bool {
        return displayedArray.contains(where: { $0.symbol == coin.symbol })
    }
}

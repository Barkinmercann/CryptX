//  SettingsManager.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 20.07.2024.
//  

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    let defaults = UserDefaults.standard
    
    private init() {
        if defaults.object(forKey: "settingsArray") == nil {
            setDefaultCoins()
        }
        startPeriodicUpdates()
    }
    
    private func setDefaultCoins() {
        let numbers = (1...100).map { String($0) }
        let formattedNumbers = numbers.joined(separator: ",")
        
        NetworkManager.shared.getCoins(by: formattedNumbers) { [weak self] coinData, error in
            guard let self = self, let coinData = coinData, error == nil else {
                print("Error fetching coin data: \(String(describing: error))")
                return
            }
            
            var defaultCoins: [[String: String]] = []
            
            if let coinDict = coinData.data {
                for (_, coinInfo) in coinDict {
                    if let name = coinInfo.name, let symbol = coinInfo.symbol, let price = coinInfo.quote?.usd?.price {
                        let coinDetails: [String: String] = [
                            "name": name,
                            "symbol": symbol,
                            "price": "$\(String(format: "%.2f", price))",
                            "amount": "N/A",
                            "icon": "xrp-icon"
                        ]
                        defaultCoins.append(coinDetails)
                    }
                }
            }
            defaultCoins.sort { ($0["name"] ?? "") < ($1["name"] ?? "") }
            
            self.defaults.set(defaultCoins, forKey: "settingsArray")
            self.defaults.set(defaultCoins, forKey: "DisplayedArray")
            NotificationCenter.default.post(name: Notification.Name("DisplayedCoinsChanged"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("SettingsDataUpdated"), object: nil)
        }
    }
    
    func resetDefaults() {
        defaults.removeObject(forKey: "settingsArray")
        defaults.removeObject(forKey: "DisplayedArray")
        setDefaultCoins()
    }
    
    var settingsArray: [[String: String]] {
        return defaults.array(forKey: "settingsArray") as? [[String: String]] ?? []
    }
    
    var displayedArray: [[String: String]] {
        get {
            return defaults.array(forKey: "DisplayedArray") as? [[String: String]] ?? []
        }
        set {
            defaults.set(newValue, forKey: "DisplayedArray")
            NotificationCenter.default.post(name: Notification.Name("DisplayedCoinsChanged"), object: nil)
        }
    }
    
    func isCoinDisplayed(_ coin: [String: String]) -> Bool {
        return displayedArray.contains(where: { $0["symbol"] == coin["symbol"] })
    }
    
    private func startPeriodicUpdates() {
        Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            self?.setDefaultCoins()
            print("New data fetched")
        }
    }
}

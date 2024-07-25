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
            let numbers = (1...100).map { String($0) }
            let formattedNumbers = numbers.joined(separator: ",")
            getAndSetCoins(ids: formattedNumbers)
        }
        startPeriodicUpdates()
    }
    
    private func getAndSetCoins(ids: String) {
        NetworkManager.shared.getCoins(by: ids) { [weak self] coinData, error in
            guard let self = self, let coinData = coinData, error == nil else {
                print("Error fetching coin data: \(String(describing: error))")
                return
            }
            
            var defaultCoins: [[String: String]] = []
            
            if let coinDict = coinData.data {
                for (id, coinInfo) in coinDict {
                    if let name = coinInfo.name, let symbol = coinInfo.symbol, let price = coinInfo.quote?.usd?.price {
                        let coinDetails: [String: String] = [
                            "id": "\(id)",
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
            
            // Sorting Descending Price
            defaultCoins.sort {
                guard let price1 = Double($0["price"]?.replacingOccurrences(of: "$", with: "") ?? "0"),
                      let price2 = Double($1["price"]?.replacingOccurrences(of: "$", with: "") ?? "0") else {
                    return false
                }
                return price1 > price2
            }
            if defaults.object(forKey: "settingsArray") == nil {
                defaults.set(defaultCoins, forKey: "settingsArray")
                NotificationCenter.default.post(name: Notification.Name("SettingsDataUpdated"), object: nil)
            }
            
            defaults.set(defaultCoins, forKey: "displayedArray")
            NotificationCenter.default.post(name: Notification.Name(AppConstants.NotificationName.displayedArrayChanged), object: nil)
        }
    }
    
    func resetDefaults() {
        defaults.removeObject(forKey: "settingsArray")
        defaults.removeObject(forKey: "displayedArray")
        let numbers = (1...100).map { String($0) }
        let formattedNumbers = numbers.joined(separator: ",")
        getAndSetCoins(ids: formattedNumbers)
    }
    
    var settingsArray: [[String: String]] {
        return defaults.array(forKey: "settingsArray") as? [[String: String]] ?? []
    }
    
    var displayedArray: [[String: String]] {
        get {
            return defaults.array(forKey: "displayedArray") as? [[String: String]] ?? []
        }
        set {
            defaults.set(newValue, forKey: "displayedArray")
            NotificationCenter.default.post(name: Notification.Name(AppConstants.NotificationName.displayedArrayChanged), object: nil)
        }
    }
    
    func isCoinDisplayed(_ coin: [String: String]) -> Bool {
        return displayedArray.contains(where: { $0["symbol"] == coin["symbol"] })
    }
    
    private func startPeriodicUpdates() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            var idsArray: [String] = []
            for coin in self.displayedArray {
                if let id = coin["id"] {
                    idsArray.append(id)
                }
            }
            let ids = idsArray.joined(separator: ",")
            
            self.getAndSetCoins(ids: ids)
            print("New data fetched")
            
            NotificationCenter.default.post(name: NSNotification.Name(AppConstants.NotificationName.chartValuesChanged), object: nil)
        }
            
    }
}

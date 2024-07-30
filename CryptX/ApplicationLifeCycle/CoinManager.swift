//
//  CoinManager.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 31.07.2024.
//

import Foundation
import UIKit

class CoinManager {
    
    static let shared = CoinManager()
    
    /// This function get the data, sorts it by price, add the data to userdefaults array and notifies the relevant classes for UI update.
    /// - Parameter ids: Comma-separated string of coin IDs.
    func getAndSetCoins(ids: String, reset: Bool = false) {
        DispatchQueue.global().async {
            NetworkManager.shared.getCoins(by: ids) { coinData, error in
                guard let coinData = coinData, error == nil else {
                    print("Error fetching coin data: \(String(describing: error))")
                    return
                }
                
                var defaultCoins: [CryptoCoin] = []
                
                if let coinDict = coinData.data {
                    for (id, coinInfo) in coinDict {
                        if let name = coinInfo.name, let symbol = coinInfo.symbol,
                           let price = coinInfo.quote?.usd?.price {
                            let amount = SettingsManager.shared.numberOfCoins[symbol] ?? 0
                            let coinDetails = CryptoCoin(id: "\(id)",
                                                         name: name,
                                                         symbol: symbol,
                                                         price: "$\(String(format: "%.2f", price))",
                                                         amount: "\(amount)",
                                                         icon: "xrp-icon")
                            defaultCoins.append(coinDetails)
                        }
                    }
                }
                
                defaultCoins.sort {
                    guard let price1 = Double($0.price.replacingOccurrences(of: "$", with: "")),
                          let price2 = Double($1.price.replacingOccurrences(of: "$", with: "")) else {
                        return false
                    }
                    return price1 > price2
                }
                
                if reset == true {
                    SettingsManager.shared.settingsArray = defaultCoins
                    NotificationCenter.default.post(name: Notification.Name("SettingsDataUpdated"), object: nil)
                }
                
            SettingsManager.shared.displayedArray = defaultCoins
            NotificationCenter.default.post(name: Notification.Name(AppConstants.NotificationName.displayedArrayChanged), object: nil)
            }
        }
    }
    
    /// Updates data every 60 seconds.
    func startPeriodicUpdates() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            var idsArray: [String] = []
            for coin in SettingsManager.shared.displayedArray {
                idsArray.append(coin.id)
            }
            let ids = idsArray.joined(separator: ",")
            
            self.getAndSetCoins(ids: ids)
            print("New data fetched")
            
            NotificationCenter.default.post(name: NSNotification.Name(AppConstants.NotificationName.chartValuesChanged), object: nil)
        }
    }
}

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    private init() {
        if defaults.object(forKey: "settingsArray") == nil {
            let defaultCoins = [
                ["name": "Ethereum", "symbol": "ETH", "price": "$503.12", "amount": "50 ETH", "icon": "ethereum-icon"],
                ["name": "Bitcoin", "symbol": "BTC", "price": "$26927", "amount": "2.05 BTC", "icon": "btc-icon"],
                ["name": "Litecoin", "symbol": "LTC", "price": "$6927", "amount": "2.05 LTC", "icon": "litecoin-icon"],
                ["name": "Ripple", "symbol": "XRP", "price": "$4637", "amount": "2.05 XRP", "icon": "xrp-icon"],
                ["name": "XCoin", "symbol": "XC", "price": "$1000", "amount": "2.05 XCO", "icon": "xrp-icon"],
                ["name": "ZCoin", "symbol": "ZC", "price": "$3000", "amount": "2.05 ZCO", "icon": "xrp-icon"],
                ["name": "Cardano", "symbol": "ADA", "price": "$1.20", "amount": "500 ADA", "icon": "xrp-icon"],
                ["name": "Polkadot", "symbol": "DOT", "price": "$14.50", "amount": "100 DOT", "icon": "xrp-icon"],
                ["name": "Chainlink", "symbol": "LINK", "price": "$23.45", "amount": "200 LINK", "icon": "xrp-icon"],
                ["name": "Stellar", "symbol": "XLM", "price": "$0.25", "amount": "1000 XLM", "icon": "xrp-icon"],
                ["name": "Monero", "symbol": "XMR", "price": "$234.56", "amount": "10 XMR", "icon": "xrp-icon"],
                ["name": "Dash", "symbol": "DASH", "price": "$150.67", "amount": "20 DASH", "icon": "xrp-icon"]]
            
            defaults.set(defaultCoins, forKey: "settingsArray")
            defaults.set(defaultCoins, forKey: "DisplayedArray")
        }
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
}

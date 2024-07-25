//
//  NetworkManager.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 24.07.2024.
//

import Alamofire
import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getCoins(by id: String, completionHandler: @escaping (CoinDataModel?, String?) -> Void) {
        
        let parameters: [String: Any] = [
            "id": id
        ]
        
        let headers: HTTPHeaders = [
            "X-CMC_PRO_API_KEY": "d44f0951-4104-49cc-ae8d-1a58fe044c8a",
            "Accept": "application/json"
        ]
        
        AF.request("https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest",
                   method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: CoinDataModel.self) { response in
                if let coin = response.value {
                    completionHandler(coin, nil)
                } else if let error = response.error {
                    completionHandler(nil, error.errorDescription)
                } else {
                    completionHandler(nil, "Unknown Error")
                }
        }
    }
}

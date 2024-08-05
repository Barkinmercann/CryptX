//
//  AppConstants.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 16.07.2024.
//

import Foundation

public struct AppConstants {
    
}

extension AppConstants {
    
    struct Segue {
        
        static let enterTheApp = "enterTheApp"
        
        static let homepageToSettings = "homepageToSettings"
        
        static let detailsToSettings = "detailsToSettings"
        
        static let logInToSignUp = "logInToSignUp"
        
        static let successLogIn = "successLogIn"
        
        static let successSignUp = "successSignUp"
        
        static let logoutSegue = "logoutSegue"
    }
    
    struct NotificationName {
        
        static let displayedArrayChanged = "displayedArrayChanged"
        
        static let chartValuesChanged = "chartValuesChanged"
        
        static let profileDataUpdated = "profileDataUpdated"
        
        static let balanceUpdated = "balanceUpdated"
        
        static let numberOfCoinsUpdated = "numberOfCoinsUpdated"
    }
}

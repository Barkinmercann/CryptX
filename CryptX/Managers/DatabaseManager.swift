//
//  DatabaseManager.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 4.08.2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Firestore.firestore()
    
    private init() {}
        
    /// Fetches user data from Firestore
    /// - Parameter email: The user's email
    /// - Parameter completion: Completion handler to return user data or error
    func fetchUserData(email: String, completion: @escaping (Result<UserData, Error>) -> Void) {
        database.collection("users").document(email).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let balance = data?["currentBalance"] as? Double ?? 0.0
                let numberOfCoins = data?["numberOfCoins"] as? [String: Double] ?? [:]
                let profileName = data?["profileName"] as? String ?? ""
                let userData = UserData(balance: balance, numberOfCoins: numberOfCoins, profileName: profileName)
                completion(.success(userData))
            } else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user data found"])))
            }
        }
    }

    /// Updates user data in Firestore
    /// - Parameters:
    ///   - email: The user's email
    ///   - balance: The user's current balance
    ///   - numberOfCoins: Dictionary of coin quantities
    ///   - profileName: The user's profile name
    func updateUserData(email: String, balance: Double, numberOfCoins: [String: Double], profileName: String) {
        database.collection("users").document(email).setData([
            "currentBalance": balance,
            "numberOfCoins": numberOfCoins,
            "profileName": profileName
        ]) { error in
            if let error = error {
                print("Error updating user data: \(error)")
            }
        }
    }
    
    func updateBalance(_ balance: Double) {
        database.collection("users").document(SettingsManager.shared.currentEmail).updateData([
            "currentBalance": balance
        ]) { error in
            if let error = error {
                print("Error updating balance: \(error.localizedDescription)")
            } else {
                print("Balance successfully updated.")
            }
        }
    }
    
    func updateNumberOfCoins(_ numberOfCoins: [String: Double]) {
        database.collection("users").document(SettingsManager.shared.currentEmail).updateData([
            "numberOfCoins": numberOfCoins
        ]) { error in
            if let error = error {
                print("Error updating number of coins: \(error.localizedDescription)")
            } else {
                print("Number of coins successfully updated.")
            }
        }
    }
    
    func updateProfileName(_ profileName: String) {
        database.collection("users").document(SettingsManager.shared.currentEmail).updateData([
            "profileName": profileName
        ]) { error in
            if let error = error {
                print("Error updating profile name: \(error.localizedDescription)")
            } else {
                print("Profile name successfully updated.")
            }
        }
    }
}

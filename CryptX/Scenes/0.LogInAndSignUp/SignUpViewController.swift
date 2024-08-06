//
//  SignUpViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 3.08.2024.
//

import FirebaseAuth
import UIKit

class SignUpViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var appNameLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCosmetics()
    }
    
    // MARK: Set Up
    
    func setupCosmetics() {
        appNameLabel.text = "CryptX"
        appNameLabel.font = UIFont(name: AppFonts.poppinsSemiBold, size: 64)
        if let fullText = appNameLabel.text {
        let attributedString = NSMutableAttributedString(string: fullText)
        let nsRange = NSRange(location: 5, length: 1)
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor(hexString: AppColors.primaryPurple),
                                      range: nsRange)
        appNameLabel.attributedText = attributedString
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    // MARK: Sign Up
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
            showErrorAlert(message: "Please ensure passwords match and all fields are filled")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: "Sign up failed: \(error.localizedDescription)")
                return
            }
            print(authResult!)
            self.initializeUserData(email: email)
            SettingsManager.shared.currentEmail = email
            SettingsManager.shared.isLoggedIn = true
        }
    }

    private func initializeUserData(email: String) {
        let initialBalance = 0.0
        let initialNumberOfCoins: [String: Double] = [:]
        DatabaseManager.shared.updateUserData(email: email, balance: initialBalance, numberOfCoins: initialNumberOfCoins, profileName: "User")
        performSegue(withIdentifier: AppConstants.Segue.successSignUp, sender: self)
    }
}

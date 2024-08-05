//
//  LoginViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 3.08.2024.
//

import FirebaseAuth
import UIKit

class LoginViewController: BaseViewController {
    
    // MARK: - Outlets

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var appNameLabel: UILabel!
    @IBOutlet private weak var passwordVisibilityButton: UIButton!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsManager.shared.resetAllSystem()
        setupCosmetics()
    }
    
    // MARK: - Set Up
    
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
    
    @IBAction func passwordVisiblePressed(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    // MARK: - Reset Password
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        let email = emailTextField.text ?? ""
        guard !email.isEmpty else {
            showErrorAlert(message: "Please enter an email.")
            return
        }
        
        let alert = UIAlertController(title: "Reset Password", message: "Are you sure you want to reset your password?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            self.performResetPassword(email: email)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func performResetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                let alert = UIAlertController(title: "Success", message: "Password reset email has been sent.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Log In & Sign Up
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Please enter both email and password")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: "Login failed: \(error.localizedDescription)")
                return
            }
            print(authResult!)
            self.fetchUserDataAndUpdateSettings(email: email)
            SettingsManager.shared.currentEmail = email
            SettingsManager.shared.isLoggedIn = true
        }
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: AppConstants.Segue.logInToSignUp, sender: self)
    }
    
    private func fetchUserDataAndUpdateSettings(email: String) {
        DatabaseManager.shared.fetchUserData(email: email) { result in
            switch result {
            case .success(let (balance, numberOfCoins)):
                SettingsManager.shared.currentBalance = balance
                SettingsManager.shared.numberOfCoins = numberOfCoins
                self.performSegue(withIdentifier: AppConstants.Segue.successLogIn, sender: self)
            case .failure(let error):
                self.showErrorAlert(message: "Failed to fetch user data: \(error.localizedDescription)")
            }
        }
    }
}

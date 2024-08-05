//
//  HomepageViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 16.07.2024.
//

import Foundation
import UIKit

class HomepageViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var avatarImageButton: UIButton!
    @IBOutlet private weak var greetingTextLabel: UILabel!
    @IBOutlet private weak var settingsButton: UIButton!
    @IBOutlet private weak var gradientImageView: UIImageView!
    @IBOutlet private weak var currentBalanceTextLabel: UILabel!
    @IBOutlet private weak var balanceValueLabel: UILabel!
    @IBOutlet private weak var percentageValueLabel: UILabel!
    @IBOutlet private weak var depositButton: UIButton!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var withdrawButton: UIButton!
    @IBOutlet private weak var seeAllButton: UIButton!
    @IBOutlet private weak var holdingsTextLabel: UILabel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        setupCosmetics()
        addObserver()
    }
    
    // MARK: - Notification Handlers
    
    func addObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(AppConstants.NotificationName.displayedArrayChanged), object: nil, queue: .init()) { _ in
            self.displayedArrayChanged()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(AppConstants.NotificationName.profileDataUpdated), object: nil, queue: .init()) { _ in
            self.handleProfileDataUpdate()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(AppConstants.NotificationName.balanceUpdated), object: nil, queue: .init()) { _ in
            self.handleBalanceUpdate()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(AppConstants.NotificationName.numberOfCoinsUpdated), object: nil, queue: .init()) { _ in
            self.displayedArrayChanged()
        }
    }
    
    func handleProfileDataUpdate() {
        DispatchQueue.main.async {
            self.prepareGreetingLabel()
            self.prepareAvatarImage()
        }
    }
        
    func displayedArrayChanged() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func handleBalanceUpdate() {
        DispatchQueue.main.async {
            self.balanceValueLabel.text = String(format: "$%.2f", SettingsManager.shared.currentBalance)
        }
    }
    
    // MARK: - Avatar and Settings Actions
    
    @IBAction func avatarImageButtonPressed(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: AppConstants.Segue.homepageToSettings, sender: self)
    }
    
    // MARK: - Deposit and Withdraw Button Actions
    
    @IBAction func depositButtonPressed(_ sender: Any) {
        buttonAction("deposit")
    }
    
    @IBAction func withdrawButtonPressed(_ sender: Any) {
        buttonAction("withdraw")
    }
    
    func buttonAction(_ action: String) {
        let alert = UIAlertController(title: action.capitalized, message: "Enter the amount to \(action)", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        let alertAction = UIAlertAction(title: action.capitalized, style: .default) { _ in
            if let amountText = alert.textFields?.first?.text, let amount = Double(amountText), amount > 0 {
                self.updateBalance(amount: amount, action: action)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateBalance(amount: Double, action: String) {
        var newBalance = SettingsManager.shared.currentBalance
        if action == "deposit" {
            newBalance += amount
            if newBalance > 1_000_000 {
                showErrorAlert(message: "Deposit exceeds the maximum balance limit of $1,000,000.")
                return
            }
        } else {
            newBalance -= amount
            if newBalance < 0 {
                showErrorAlert(message: "Withdrawal exceeds the available balance.")
                return
            }
        }
        
        SettingsManager.shared.currentBalance = newBalance
        balanceValueLabel.text = String(format: "$%.2f", SettingsManager.shared.currentBalance)
    }
    
    // MARK: - Set up Cosmetics
    
    func prepareGreetingLabel() {
        let text = "Hello \(SettingsManager.shared.profileName)"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: UIFont(name: AppFonts.poppinsRegular, size: 24)!,
                                      range: NSRange(location: 0, length: 5))
        attributedString.addAttribute(.font, value: UIFont(name: AppFonts.poppinsSemiBold, size: 24)!,
                                      range: NSRange(location: 6, length: (text.count - 6)))
        self.greetingTextLabel.attributedText = attributedString
    }
    
    func prepareAvatarImage() {
        avatarImageView.image = SettingsManager.shared.profilePhoto
    }
    
    func setupCosmetics() {
        
        prepareGreetingLabel()
        prepareAvatarImage()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageButton.layer.cornerRadius = avatarImageButton.frame.size.width / 2
        
        settingsButton.setImage(.settings, for: .normal)
        
        gradientImageView.image = .gradient
        
        currentBalanceTextLabel.text = "Current Balance"
        currentBalanceTextLabel.font = UIFont(name: AppFonts.poppinsRegular, size: 18)
        currentBalanceTextLabel.textColor = UIColor(hexString: "#272727")
        
        balanceValueLabel.text = String(format: "$%.2f", SettingsManager.shared.currentBalance)
        balanceValueLabel.font = UIFont(name: AppFonts.poppinsBold, size: 28)
        balanceValueLabel.textColor = UIColor(hexString: "#1D1D1D")
        
        percentageValueLabel.text = "10.2%"
        percentageValueLabel.font = UIFont(name: AppFonts.poppinsSemiBold, size: 18)
        percentageValueLabel.textColor = UIColor(hexString: AppColors.primaryPurple)
        
        arrowImageView.image = .arrowUp
        
        depositButton.setTitle("Deposit", for: .normal)
        depositButton.titleLabel?.font = UIFont(name: AppFonts.poppinsRegular, size: 16)
        depositButton.tintColor = UIColor(hexString: AppColors.primaryPurple)
        depositButton.layer.cornerRadius = 18
        depositButton.layer.masksToBounds = true
        
        withdrawButton.setTitle("Withdraw", for: .normal)
        withdrawButton.titleLabel?.font = UIFont(name: AppFonts.poppinsRegular, size: 16)
        
        withdrawButton.layer.cornerRadius = 18
        withdrawButton.layer.borderWidth = 1.0
        withdrawButton.layer.borderColor = UIColor.white.cgColor
        withdrawButton.layer.masksToBounds = true
        
        holdingsTextLabel.text = "Holdings"
        holdingsTextLabel.font = UIFont(name: AppFonts.poppinsBold, size: 20)
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(string: "See All",
                                                        attributes: yourAttributes)
        seeAllButton.setAttributedTitle(attributeString, for: .normal)
        
        seeAllButton.titleLabel?.font = UIFont(name: AppFonts.poppinsMedium, size: 14)
    }
}

// MARK: - Table View Controller
extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsManager.shared.displayedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let coinCell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.identifier,
                                                           for: indexPath) as? CoinTableViewCell else { return UITableViewCell() }
        
        let coin = SettingsManager.shared.displayedArray[indexPath.row]
        coinCell.configureCell(
            name: coin.name,
            symbol: coin.symbol,
            value: coin.price,
            symbolValue: String(SettingsManager.shared.numberOfCoins[coin.symbol] ?? 0),
            image: coin.icon)
        return coinCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
            let parameter = SettingsManager.shared.displayedArray[indexPath.row]
            if let detailsVC = tabBarController.selectedViewController as? DetailsViewController {
                detailsVC.updateLabels(name: parameter.name,
                                       symbol: parameter.symbol,
                                       value: parameter.price,
                                       symbolValue: String(SettingsManager.shared.numberOfCoins[parameter.symbol] ?? 0),
                                       image: parameter.icon)
            }
        }
    }
}

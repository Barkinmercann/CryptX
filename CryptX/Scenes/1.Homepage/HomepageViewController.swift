//  HomepageViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 16.07.2024.
//

import Foundation
import UIKit

class HomepageViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        setupCosmetics()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(AppConstants.NotificationName.displayedArrayChanged), object: nil, queue: .init()) { _ in
            self.displayedArrayChanged()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(AppConstants.NotificationName.profileDataUpdated), object: nil, queue: .init()) { _ in
            self.handleProfileDataUpdate()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    @IBAction func avatarImageButtonPressed(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
    }
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: AppConstants.Segue.homepageToSettings, sender: self)
    }
    
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
        prepareAvatarImage()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageButton.layer.cornerRadius = avatarImageButton.frame.size.width / 2
        
        prepareGreetingLabel()
        
        settingsButton.setImage(.settings, for: .normal)
        
        gradientImageView.image = .gradient
        
        currentBalanceTextLabel.text = "Current Balance"
        currentBalanceTextLabel.font = UIFont(name: AppFonts.poppinsRegular, size: 18)
        currentBalanceTextLabel.textColor = UIColor(hexString: "#272727")
        
        balanceValueLabel.text = "$87,430.12"
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
            name: coin["name"] ?? "",
            symbol: coin["symbol"] ?? "",
            value: coin["price"] ?? "",
            symbolValue: coin["amount"] ?? "",
            image: coin["icon"] ?? "")
        
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
            if let detailsVC = tabBarController.selectedViewController as? DetailsViewController {
                let parameter = SettingsManager.shared.displayedArray[indexPath.row]
                detailsVC.updateLabels(name: parameter["name"] ?? "",
                                       symbol: parameter["symbol"] ?? "",
                                       value: parameter["price"] ?? "",
                                       symbolValue: parameter["amount"] ?? "",
                                       image: parameter["icon"] ?? "")
            }
        }
    }
}

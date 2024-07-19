//
//  HomepageViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 16.07.2024.
//

import Foundation
import UIKit

class HomepageViewController: UIViewController {
    
    var coinArray = [
            ["name": "Ethereum", "symbol": "ETH", "price": "$503.12", "amount": "50 ETH", "icon": "ethereum-icon"],
            ["name": "Bitcoin", "symbol": "BTC", "price": "$26927", "amount": "2.05 BTC", "icon": "btc-icon"],
            ["name": "Litecoin", "symbol": "LTC", "price": "$6927", "amount": "2.05 LTC", "icon": "litecoin-icon"],
            ["name": "Ripple", "symbol": "XRP", "price": "$4637", "amount": "2.05 XRP", "icon": "xrp-icon"],
            ["name": "XCoin", "symbol": "XC", "price": "$1000", "amount": "2.05 XCO", "icon": "xrp-icon"],
            ["name": "ZCoin", "symbol": "ZC", "price": "$3000", "amount": "2.05 ZCO", "icon": "xrp-icon"]
        ]
        
    var name = "Barkın"
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var greetingTextLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var currentBalanceTextLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var percentageValueLabel: UILabel!
    @IBOutlet weak var depositButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var holdingsTextLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.image = .avatarIcon
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        setupCosmetics()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails", let detailsVC = segue.destination as? DetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
            detailsVC.coin = coinArray[indexPath.row]
        }
    }
    
    func setupCosmetics() {
        
        let text = "Hello \(name)"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: UIFont(name: AppFonts.poppinsRegular, size: 24)!,
                                      range: NSRange(location: 0, length: 5))
        attributedString.addAttribute(.font, value: UIFont(name: AppFonts.poppinsSemiBold, size: 24)!,
                                      range: NSRange(location: 6, length: (text.count - 6)))
        greetingTextLabel.attributedText = attributedString
        
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
        depositButton.tintColor = UIColor(hexString:AppColors.primaryPurple)
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let coinCell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.identifier,
                                                               for: indexPath) as? CoinTableViewCell else { return UITableViewCell() }
        
        coinCell.iconBackgroundView.layer.cornerRadius = 6
        coinCell.iconBackgroundView.backgroundColor = UIColor(hexString: AppColors.coinIconColor)
        let coin = coinArray[indexPath.row]
                coinCell.configureCell(
                    name: coin["name"] ?? "",
                    symbol: coin["symbol"] ?? "",
                    value: coin["price"] ?? "",
                    symbolValue: coin["amount"] ?? "",
                    image: coin["icon"] ?? ""
                )
        return coinCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82       }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showDetails", sender: self)
    }
}

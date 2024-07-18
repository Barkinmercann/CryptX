//
//  HomepageViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 16.07.2024.
//

import Foundation
import UIKit

class HomepageViewController: UIViewController {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.image = .avatarIcon
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        
        setupCosmetics()
        
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
        balanceValueLabel.font = UIFont(name: AppFonts.poppinsBold, size: 24)
        balanceValueLabel.textColor = UIColor(hexString: "#1D1D1D")
        
        percentageValueLabel.text = "10.2%"
        percentageValueLabel.font = UIFont(name: AppFonts.poppinsSemiBold, size: 15)
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

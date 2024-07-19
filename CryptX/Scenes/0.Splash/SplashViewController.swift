//
//  ViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 16.07.2024.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {

    @IBOutlet private weak var header1TextLabel: UILabel!
    @IBOutlet private weak var header2TextLabel: UILabel!
    @IBOutlet private weak var header3TextLabel: UILabel!
    @IBOutlet private weak var splashImageView: UIImageView!
    @IBOutlet private weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCosmetics()
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: AppConstants.Segue.enterTheApp, sender: self)
    }
    
    func setupCosmetics() {
        
        splashImageView.image = .splash
        
        // Header1 Cosmetics (Include last letter color change)
        header1TextLabel.text = "CryptX"
        header1TextLabel.font = UIFont(name: AppFonts.poppinsBold, size: 64)
        if let fullText = header1TextLabel.text {
            let attributedString = NSMutableAttributedString(string: fullText)
            let nsRange = NSRange(location: 5, length: 1)
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor(hexString: AppColors.primaryPurple),
                                          range: nsRange)
            header1TextLabel.attributedText = attributedString
        }
        
        header2TextLabel.text = "Jump start your crypto portfolio"
        header2TextLabel.font = UIFont(name: AppFonts.poppinsSemiBold, size: 32)
    
        header3TextLabel.text = "Take your investment portfolio to next level"
        header3TextLabel.font = UIFont(name: AppFonts.poppinsMedium, size: 14)
        
        startButton.setTitle("Get Started", for: .normal)
        startButton.titleLabel?.font = UIFont(name: AppFonts.poppinsMedium, size: 16)
        startButton.tintColor = UIColor(hexString: AppColors.primaryPurple)
        startButton.layer.cornerRadius = 16
        startButton.layer.masksToBounds = true
    }
}

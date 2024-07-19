//
//  CoinTableViewCell.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 18.07.2024.
//

import Foundation
import UIKit

class CoinTableViewCell: UITableViewCell {
    
    static let identifier = "coinCell"
    
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinSymbolLabel: UILabel!
    
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var coinValueLabel: UILabel!
    @IBOutlet weak var coinSymbolValueLabel: UILabel!
    @IBOutlet weak var coinIcon: UIImageView!
    @IBOutlet weak var graphImageView: UIImageView!

    public func configureCell(name: String, symbol: String, value: String, symbolValue: String, image: String) {
        coinNameLabel.text = name
        coinNameLabel.font = UIFont(name: AppFonts.poppinsBold, size: 16)
        coinSymbolLabel.text = symbol
        coinSymbolLabel.font = UIFont(name: AppFonts.poppinsRegular, size: 14)
        coinSymbolLabel.textColor = UIColor(hexString: AppColors.primaryGrey)
        coinValueLabel.text = value
        coinValueLabel.font = UIFont(name: AppFonts.poppinsBold, size: 16)
        coinSymbolValueLabel.text = symbolValue
        coinSymbolValueLabel.font = UIFont(name: AppFonts.poppinsBold, size: 10)
        coinSymbolValueLabel.textColor = UIColor(hexString: AppColors.primaryGrey)
        coinIcon.image = UIImage(named: image)
        graphImageView.image = .increaseGraph
    }
    
    
}

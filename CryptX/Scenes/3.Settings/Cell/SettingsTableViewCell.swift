//
//  SettingsTableViewCell.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 20.07.2024.
//

import Foundation
import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "settingsCell"
    
    @IBOutlet private weak var iconBackgroundView: UIView!
    @IBOutlet private weak var coinIcon: UIImageView!
    @IBOutlet private weak var coinNameLabel: UILabel!
    @IBOutlet private weak var switchButton: UISwitch!
    
    public func configureCell(name: String, image: String, switchTag: Int) {
        coinNameLabel.text = name
        coinNameLabel.font = UIFont(name: AppFonts.poppinsBold, size: 16)
        coinIcon.image = UIImage(named: image)
        iconBackgroundView.layer.cornerRadius = 6
        iconBackgroundView.backgroundColor = UIColor(hexString: AppColors.coinIconColor)
    }
}

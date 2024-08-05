//
//  CoinCollectionViewCell.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 19.07.2024.
//

import Foundation
import UIKit

class CoinCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var cellButton: UIButton!
    
    static let identifier = "collectionCell"
    
    public func configureCell(title: String?, tag: Int) {
        cellButton.setTitle(title, for: .normal)
        cellButton.tag = tag
    }
    
}

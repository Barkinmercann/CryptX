//
//  BaseViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 30.07.2024.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

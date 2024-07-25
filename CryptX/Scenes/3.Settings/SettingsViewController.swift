//
//  SettingsTableViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 20.07.2024.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
        
    var coinArray: [[String: String]] = []
    var selectedCoins: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }

    func setCoins(_ coins: [[String: String]]) {
        self.coinArray = coins
    }

    @IBAction func resetButtonPressed(_ sender: Any) {
        SettingsManager.shared.resetDefaults()
        self.tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(AppConstants.NotificationName.displayedArrayChanged), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsManager.shared.settingsArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier,
                                                               for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }

        let settingsArray = SettingsManager.shared.settingsArray
        guard indexPath.row < settingsArray.count else {
            return UITableViewCell()
        }

        let coin = settingsArray[indexPath.row]
                settingsCell.configureCell(name: coin["name"] ?? "Coin",
                                           image: coin["icon"] ?? "",
                                           switchTag: indexPath.row,
                                           isOn: SettingsManager.shared.isCoinDisplayed(coin))
        
        return settingsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
}

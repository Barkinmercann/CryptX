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
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier,
                                                               for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }

        let coin = coinArray[indexPath.row]
        
        settingsCell.configureCell(name: coin["name"] ?? "Coin",
                                   image: coin["icon"] ?? "",
                                   switchTag: indexPath.row)
        
        return settingsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
}

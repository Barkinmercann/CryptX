//
//  DetailsViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 19.07.2024.
//

import DGCharts
import TinyConstraints
import UIKit

class DetailsViewController: BaseViewController, ChartViewDelegate {
    
    // MARK: - Outlets

    @IBOutlet private weak var iconBackgroundView: UIView!
    @IBOutlet private weak var coinNameLabel: UILabel!
    @IBOutlet private weak var coinSymbolLabel: UILabel!
    @IBOutlet private weak var coinValueLabel: UILabel!
    @IBOutlet private weak var coinSymbolValueLabel: UILabel!
    @IBOutlet private weak var coinIcon: UIImageView!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var chartContainerView: UIView!
    
    @IBOutlet private weak var buyButton: UIButton!
    @IBOutlet private weak var sellButton: UIButton!
    
    @IBOutlet private weak var atPriceLabel: UILabel!
    @IBOutlet private weak var atPriceValueLabel: UILabel!
    
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var amountValueLabel: UILabel!
    
    @IBOutlet private weak var percentage100Label: UIButton!
    @IBOutlet private weak var percentage50Label: UIButton!
    @IBOutlet private weak var percentage25Label: UIButton!
    
    var coin: [[String: String]] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        if let startCoin = SettingsManager.shared.displayedArray.first {
            updateLabels(name: startCoin["name"] ?? "",
                         symbol: startCoin["symbol"] ?? "",
                         value: startCoin["price"] ?? "",
                         symbolValue: startCoin["amount"] ?? "",
                         image: startCoin["icon"] ?? "")
        }
        
        setupCosmetics()
        collectionView.reloadData()
    
        NotificationCenter.default.addObserver(forName: NSNotification.Name(AppConstants.NotificationName.displayedArrayChanged), object: nil, queue: .init()) { _ in
                self.displayedArrayChanged()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData(for: SettingsManager.shared.displayedArray.first)
    }

    // MARK: - Chart View
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .black
        return chartView
    }()
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(for coin: [String: String]?) {
        let yValues = (0..<30).map { iterator -> ChartDataEntry in
            let yValue = Double.random(in: 1_000...6_000)
            return ChartDataEntry(x: Double(iterator), y: yValue)
        }
        
        let set1 = LineChartDataSet(entries: yValues)
        
        set1.drawCirclesEnabled = false
        set1.setColor(UIColor(hexString: AppColors.primaryPurple))
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
        
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.enabled = false
        
        lineChartView.legend.enabled = false
    }
    
    // MARK: - Settings And Cell Button
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: AppConstants.Segue.detailsToSettings, sender: self)
    }
    
    @IBAction func cellButtonPressed(_ sender: UIButton) {
        let parameter = SettingsManager.shared.displayedArray[sender.tag]
        updateLabels(name: parameter["name"] ?? "",
                    symbol: parameter["symbol"] ?? "",
                    value: parameter["price"] ?? "",
                     symbolValue: String(SettingsManager.shared.numberOfCoins[parameter["symbol"] ?? ""] ?? 0),
                    image: parameter["icon"] ?? "")
        setData(for: parameter)
    }
    
    func displayedArrayChanged() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Buy and Sell Button
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        buttonAction("Buy")
    }
    
    @IBAction func sellButtonPressed(_ sender: Any) {
        buttonAction("Sell")
    }
    
    func buttonAction(_ action: String) {
        let alert = UIAlertController(title: "\(action) Coins", message: "Enter quantity:", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.keyboardType = .numberPad
            }
        let buyAction = UIAlertAction(title: "\(action)", style: .default) { [weak self] _ in
            guard let self = self,
                  let textField = alert.textFields?.first,
                  let quantityText = textField.text,
                  let quantity = Double(quantityText),
                  let coinValueText = self.coinValueLabel.text?.replacingOccurrences(of: "$", with: ""),
                  let coinValue = Double(coinValueText) else { return }

            let totalCost = coinValue * quantity
            if action == "Buy" {
                self.buyCoins(quantity: quantity, totalCost: totalCost)
            } else {
                self.sellCoins(quantity: quantity, totalCost: totalCost)
            }
        }
        alert.addAction(buyAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func buyCoins(quantity: Double, totalCost: Double) {
        if SettingsManager.shared.currentBalance >= totalCost {
            SettingsManager.shared.currentBalance -= totalCost
            updateCoinAmount(by: quantity)
        } else {
            showErrorAlert(message: "Insufficient balance to complete the transaction.")
        }
    }

    func sellCoins(quantity: Double, totalCost: Double) {
        let currentAmount = SettingsManager.shared.numberOfCoins[coinSymbolLabel.text ?? ""] ?? 0
        if currentAmount >= quantity {
            SettingsManager.shared.currentBalance += totalCost
            updateCoinAmount(by: -quantity)
        } else {
            showErrorAlert(message: "Insufficient coins to complete the transaction.")
        }
    }

    func updateCoinAmount(by quantity: Double) {
        guard let coinSymbol = coinSymbolLabel.text else { return }
        var currentAmount = SettingsManager.shared.numberOfCoins[coinSymbol] ?? 0
        currentAmount += quantity
        SettingsManager.shared.numberOfCoins[coinSymbol] = currentAmount
        self.amountValueLabel.text = "\(currentAmount)"
    }
    
    // MARK: - Set Up Cosmetics and Update Labels
    
    func setupCosmetics() {
        chartContainerView.addSubview(lineChartView)
        lineChartView.width(to: chartContainerView)
        lineChartView.height(to: chartContainerView)
        lineChartView.highlightPerTapEnabled = false
        lineChartView.highlightPerDragEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        
        buyButton.setTitle("Buy", for: .normal)
        buyButton.titleLabel?.font = UIFont(name: AppFonts.poppinsRegular, size: 16)
        buyButton.tintColor = UIColor(hexString: AppColors.primaryPurple)
        buyButton.layer.cornerRadius = 18
        buyButton.layer.masksToBounds = true
        
        sellButton.setTitle("Sell", for: .normal)
        sellButton.titleLabel?.font = UIFont(name: AppFonts.poppinsRegular, size: 16)
        sellButton.layer.cornerRadius = 18
        sellButton.layer.borderWidth = 1.0
        sellButton.layer.borderColor = UIColor.white.cgColor
        sellButton.layer.masksToBounds = true
        
        atPriceLabel.font = UIFont(name: AppFonts.poppinsRegular, size: 15)
        atPriceLabel.textColor = UIColor(hexString: "#B9C1D9")
        
        atPriceValueLabel.font = UIFont(name: AppFonts.poppinsRegular, size: 18)
        
        amountLabel.font = UIFont(name: AppFonts.poppinsRegular, size: 15)
        amountLabel.textColor = UIColor(hexString: "#B9C1D9")

        amountValueLabel.font = UIFont(name: AppFonts.poppinsRegular, size: 18)
        
        percentage25Label.titleLabel?.font = UIFont(name: AppFonts.poppinsSemiBold, size: 11)
        percentage50Label.titleLabel?.font = UIFont(name: AppFonts.poppinsRegular, size: 11)
        percentage100Label.titleLabel?.font = UIFont(name: AppFonts.poppinsRegular, size: 11)
        iconBackgroundView.layer.cornerRadius = 6
        iconBackgroundView.backgroundColor = UIColor(hexString: AppColors.coinIconColor)
    }
    
    func updateLabels(name: String, symbol: String, value: String, symbolValue: String, image: String) {
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
        atPriceValueLabel.text = value
        amountValueLabel.text = symbolValue
    }
}

// MARK: - Collection View Controller
extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingsManager.shared.displayedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinCollectionViewCell.identifier,
                                                               for: indexPath) as? CoinCollectionViewCell else { return UICollectionViewCell() }

        collectionCell.configureCell(title: SettingsManager.shared.displayedArray[indexPath.row]["symbol"],
                                     tag: indexPath.row)

        return collectionCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

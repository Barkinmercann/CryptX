import DGCharts
import TinyConstraints
import UIKit

class DetailsViewController: UIViewController, ChartViewDelegate {
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .black
        return chartView
    }()

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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coin = SettingsManager.shared.displayedArray
        
        collectionView.delegate = self
        collectionView.dataSource = self
                    
        chartContainerView.addSubview(lineChartView)
        lineChartView.width(to: chartContainerView)
        lineChartView.height(to: chartContainerView)
        
        if let startCoin = SettingsManager.shared.displayedArray.first {
            updateLabels(name: startCoin["name"] ?? "",
                         symbol: startCoin["symbol"] ?? "",
                         value: startCoin["price"] ?? "",
                         symbolValue: startCoin["amount"] ?? "",
                         image: startCoin["icon"] ?? "")
        }
        
        setupCosmetics()
        setData()
        collectionView.reloadData()
    
        NotificationCenter.default.addObserver(forName: NSNotification.Name("displayedArrayChanged"), object: nil, queue: .init()) { _ in
                self.displayedArrayChanged()
        }
    }
    
    func displayedArrayChanged() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: AppConstants.Segue.detailsToSettings, sender: self)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues)
        
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
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
    
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 2_500),
        ChartDataEntry(x: 1.0, y: 4_000),
        ChartDataEntry(x: 2.0, y: 1_500),
        ChartDataEntry(x: 3.0, y: 1_000),
        ChartDataEntry(x: 4.0, y: 6_000),
        ChartDataEntry(x: 5.0, y: 5_000),
        ChartDataEntry(x: 6.0, y: 2_000),
        ChartDataEntry(x: 7.0, y: 4_500)]
    
    @IBAction func cellButtonPressed(_ sender: UIButton) {
        let parameter = SettingsManager.shared.displayedArray[sender.tag]
        updateLabels(name: parameter["name"] ?? "",
                    symbol: parameter["symbol"] ?? "",
                    value: parameter["price"] ?? "",
                    symbolValue: parameter["amount"] ?? "",
                    image: parameter["icon"] ?? "")
    }
    
    func setupCosmetics() {
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
        atPriceValueLabel.text = symbolValue
        amountValueLabel.text = value
    }
}

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

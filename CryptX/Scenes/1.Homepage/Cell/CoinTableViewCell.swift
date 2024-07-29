//
//  CoinTableViewCell.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 18.07.2024.
//

import DGCharts
import Foundation
import TinyConstraints
import UIKit

class CoinTableViewCell: UITableViewCell, ChartViewDelegate {

    static let identifier = "coinCell"
        
    // MARK: - Outlets
        
    @IBOutlet private weak var coinNameLabel: UILabel!
    @IBOutlet private weak var coinSymbolLabel: UILabel!
    
    @IBOutlet private weak var iconBackgroundView: UIView!
    @IBOutlet private weak var coinValueLabel: UILabel!
    @IBOutlet private weak var coinSymbolValueLabel: UILabel!
    @IBOutlet private weak var coinIcon: UIImageView!
    
    @IBOutlet private weak var chartContainerView: UIView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupChart()
        setData()
    }
    
    // MARK: - Methods
    
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
        iconBackgroundView.layer.cornerRadius = 6
        iconBackgroundView.backgroundColor = UIColor(hexString: AppColors.coinIconColor)
        
        chartContainerView.addSubview(lineChartView)
        lineChartView.width(to: chartContainerView)
        lineChartView.height(to: chartContainerView)
        
        lineChartView.highlightPerTapEnabled = false
        lineChartView.highlightPerDragEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
    }
    
    // MARK: - Chart View
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .black
        return chartView
    }()
    
    private func setupChart() {
        chartContainerView.addSubview(lineChartView)
        lineChartView.width(to: chartContainerView)
        lineChartView.height(to: chartContainerView)
        
        lineChartView.highlightPerTapEnabled = false
        lineChartView.highlightPerDragEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    var randomYValues: [ChartDataEntry] {
        return (0..<30).map { iterator in
            ChartDataEntry(x: Double(iterator), y: Double.random(in: 1_000...6_000))
        }
    }
    
    public func setData() {
        let yValues = randomYValues
        
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
}

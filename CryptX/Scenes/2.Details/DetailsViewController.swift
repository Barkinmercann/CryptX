import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinSymbolLabel: UILabel!
    @IBOutlet weak var coinValueLabel: UILabel!
    @IBOutlet weak var coinSymbolValueLabel: UILabel!
    @IBOutlet weak var coinIcon: UIImageView!
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let stackView = UIStackView()

    let object = HomepageViewController()
    var coin: [String: String]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupContainerView()
        setupStackView()
        addButtonsToStackView(count: object.coinArray.count)
        if let coin = coin {
                    coinNameLabel.text = coin["name"]
                    coinSymbolLabel.text = coin["symbol"]
                    coinValueLabel.text = coin["price"]
                    coinSymbolValueLabel.text = coin["amount"]
                    if let iconName = coin["icon"] {
                        coinIcon.image = UIImage(named: iconName)
                    }
                }
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .lightGray
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .black
        scrollView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    func setupStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 28
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
    
    func addButtonsToStackView(count: Int) {
        for i in 0..<count {
            if let coin = self.coin {
                let button = UIButton(type: .system)
                button.setTitle(coin["name"], for: .normal)
                button.backgroundColor = .black
                button.setTitleColor(.white, for: .normal)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.widthAnchor.constraint(equalToConstant: 40).isActive = true
                button.heightAnchor.constraint(equalToConstant: 20).isActive = true
                button.tag = i
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(button)
            }
        }
        
        if let lastButton = stackView.arrangedSubviews.last {
            scrollView.trailingAnchor.constraint(equalTo: lastButton.trailingAnchor).isActive = true
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        self.coin = object.coinArray[sender.tag]
        updateLabels(name: coin?["name"] ?? "", symbol: coin?["symbol"] ?? "", value: coin?["price"] ?? "", symbolValue: coin?["amount"] ?? "", image: coin?["icon"] ?? "")
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
    }
}

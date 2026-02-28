import UIKit
import Kingfisher

final class BasketCell: UITableViewCell {
    
    static let basketID = "basketID"
    
    
    // MARK: UI
    
    private let cardView = UIView()
    
    private let productImage = UIImageView()
    
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    
    private let favButton = UIButton()
    private var productId: Int = 0
    private let minusButton = UIButton()
    private let countLabel = UILabel()
    private let plusButton = UIButton()
    
    private let counterContainer = UIView()
    
    private let priceLabel = UILabel()
    var onQuantityChanged: ((Int) -> Void)?
    var onImageTap: (() -> Void)?
    var onAddedToFav: (() -> Void)?
    var onRemoveRequest: (() -> Void)?
    
    // MARK: State
    private var count = 1
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        
        cardView.backgroundColor = UIColor(named: "colorWhite")
        cardView.layer.cornerRadius = 20
        cardView.layer.borderWidth = 0.2
        cardView.layer.borderColor = UIColor(named: "colorBg")?.cgColor
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        productImage.backgroundColor = UIColor(named: "colorSecondary")
        productImage.contentMode = .scaleAspectFit
        productImage.layer.cornerRadius = 20
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onImageTapped(_ :)))
        productImage.addGestureRecognizer(tap)
        productImage.isUserInteractionEnabled = true
        
        
        
     
        titleLabel.textColor = UIColor(named: "colorBlack")
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 2
        
        // DESC
        descLabel.font = .systemFont(ofSize: 13)
        descLabel.textColor = .systemGray
        descLabel.numberOfLines = 2
        
        // COUNTER
        counterContainer.backgroundColor = UIColor(named: "colorSecondary")
        counterContainer.layer.cornerRadius = 20
        counterContainer.layer.borderWidth = 0.5
        counterContainer.layer.borderColor = UIColor(named: "colorBg")?.cgColor
        counterContainer.layer.masksToBounds = true
        counterContainer.translatesAutoresizingMaskIntoConstraints = false
        counterContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        counterContainer.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        minusButton.setTitle("−", for: .normal)
        minusButton.setTitleColor(UIColor(named: "colorBlack"), for: .normal)
        minusButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        minusButton.addTarget(self, action: #selector(decrease(_ :)), for: .touchUpInside)
        
   
        
        countLabel.textAlignment = .center
        countLabel.textColor = UIColor(named: "colorBlack")
        countLabel.font = .systemFont(ofSize: 16, weight: .medium)
        countLabel.layer.borderColor = UIColor(named: "colorBg")?.cgColor
        countLabel.layer.borderWidth = 0.5
        // Plus
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.black, for: .normal)
        plusButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        plusButton.addTarget(self, action: #selector(increase), for: .touchUpInside)
        
        
        
        favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favButton.tintColor = UIColor(named: "colorBg")
        favButton.addTarget(self, action: #selector(onFav(_ :)), for: .touchUpInside)
        priceLabel.textColor = UIColor(named: "colorBg")
        
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.7
        priceLabel.numberOfLines = 1
        let counterStack = UIStackView(arrangedSubviews: [
            minusButton,
            countLabel,
            plusButton
        ])
        counterStack.axis = .horizontal
        counterStack.distribution = .fillEqually
        counterStack.translatesAutoresizingMaskIntoConstraints = false
        
        counterContainer.addSubview(counterStack)
        
        NSLayoutConstraint.activate([
            favButton.widthAnchor.constraint(equalToConstant: 25),
            favButton.heightAnchor.constraint(equalTo: favButton.widthAnchor),
            counterStack.topAnchor.constraint(equalTo: counterContainer.topAnchor),
            counterStack.leadingAnchor.constraint(equalTo: counterContainer.leadingAnchor),
            counterStack.trailingAnchor.constraint(equalTo: counterContainer.trailingAnchor),
            counterStack.bottomAnchor.constraint(equalTo: counterContainer.bottomAnchor)
        ])
        
       
        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            descLabel,
            counterContainer
        ])
        textStack.axis = .vertical
        textStack.spacing = 8
        
       
        let priceStack = UIStackView(arrangedSubviews: [
            favButton,
            priceLabel
        ])
        priceStack.axis = .vertical
        priceStack.alignment = .trailing
        priceStack.spacing = 12
        textStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStack.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // MAIN STACK
        let mainStack = UIStackView(arrangedSubviews: [
            productImage,
            textStack,
            priceStack
        ])
        mainStack.axis = .horizontal
        mainStack.spacing = 15
        mainStack.alignment = .top
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            
            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 15),
            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
            mainStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -15)
        ])
    }
    
    
    // MARK: Configure
    private func updateFav(isFavorite: Bool) {
        
        favButton.isSelected = isFavorite
        
        if isFavorite {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favButton.tintColor = .systemRed
        } else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favButton.tintColor = UIColor(named: "colorBg")
        }
    }
    func configure(with item: BasketManager.BasketItem) {
        
        productId = item.product.id
        titleLabel.text = item.product.title
        descLabel.text = item.product.description
        priceLabel.text = "$\(item.product.price)"
        
        count = item.quantity
        countLabel.text = "\(count)"
        
        if let url = URL(string: item.product.thumbnail) {
            productImage.kf.setImage(with: url)
        }
        
        let isFav = FavoritesManager.shared.isFavorite(productId)
        self.updateFav(isFavorite: isFav)
        
        
    }
    
    
    // MARK: Counter Logic
    
    @objc private func onFav(_ sender: UIButton) {
        FavoritesManager.shared.toggle(productId: productId) { [weak self] in
            guard let self = self else { return }
            self.updateFav(isFavorite: FavoritesManager.shared.isFavorite(productId))
            
            
        }
    }
        @objc private func increase(_ sender: UIButton) {
            count += 1
            countLabel.text = "\(count)"
            onQuantityChanged?(count)
        }
        
        @objc private func decrease(_ sender: UIButton) {
            
            
            if count > 1 {
                count -= 1
                countLabel.text = "\(count)"
                onQuantityChanged?(count)
            } else {
                onRemoveRequest?()
            }
            
        }
        @objc func onImageTapped(_ sender: UIButton) {
            onImageTap?()
        }
}


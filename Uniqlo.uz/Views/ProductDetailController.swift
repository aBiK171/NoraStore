//
//  ProductDetailController.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 11/02/26.
//

import UIKit
import Kingfisher

final class ProductDetailController: UIViewController {

    private let product: Product

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let customNav = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let ratingLabel = UILabel()
    private let stockLabel = PaddingLabel()
    private let brandChip = PaddingLabel()
    private let descriptionLabel = UILabel()
    private let buttonAddtoFav = UIButton()
    private let bottomCard = UIView()
    private lazy var cartBadge = UILabel()


    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "colorBg")
        self.navigationController?.isNavigationBarHidden = true
        self.initCustomNav()
        self.setupLayout()
        self.configure()
    }
    
    private func makeBadge() -> UILabel {
        let badge = UILabel()
        badge.backgroundColor = .systemRed
        badge.textColor = .white
        badge.font = .systemFont(ofSize: 12, weight: .bold)
        badge.textAlignment = .center
        badge.layer.cornerRadius = 10
        badge.clipsToBounds = true
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.isHidden = true
        return badge
    }

    private func initCustomNav() {
        

        customNav.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customNav)
        
        NSLayoutConstraint.activate([
            customNav.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            customNav.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            customNav.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            customNav.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.15)
        ])
        
        
        let buttonLeftNav = UIButton()
        buttonLeftNav.setImage(UIImage(named: "buttonBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonLeftNav.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLeftNav.tintColor = UIColor(named: "colorSecondary")
       
        buttonLeftNav.addTarget(self, action: #selector(onBack(_ :)), for: .touchUpInside)
        self.customNav.addSubview(buttonLeftNav)
        
        
        let buttonShare = UIButton()
        buttonShare.setImage(UIImage(named: "buttonShare")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonShare.tintColor = UIColor(named: "colorSecondary")
        buttonShare.translatesAutoresizingMaskIntoConstraints = false
        self.customNav.addSubview(buttonShare)
        
        
        

        let buttonRightNav = UIButton()
        buttonRightNav.setImage(UIImage(named: "buttonShopping")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonRightNav.tintColor = UIColor(named: "colorSecondary")
        buttonRightNav.translatesAutoresizingMaskIntoConstraints = false
        buttonRightNav.addTarget(self, action: #selector(toBasket(_ :)), for: .touchUpInside)
        self.customNav.addSubview(buttonRightNav)
        
        self.cartBadge = makeBadge()
        self.customNav.addSubview(cartBadge)

        
        NSLayoutConstraint.activate([
           
            
            buttonLeftNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonLeftNav.widthAnchor.constraint(equalToConstant: 30),
            buttonLeftNav.heightAnchor.constraint(equalTo: buttonLeftNav.widthAnchor),
            buttonLeftNav.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            
            buttonRightNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonRightNav.widthAnchor.constraint(equalTo: buttonLeftNav.widthAnchor),
            buttonRightNav.heightAnchor.constraint(equalTo: buttonLeftNav.widthAnchor),
            buttonRightNav.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),

            buttonShare.trailingAnchor.constraint(equalTo: buttonRightNav.leadingAnchor, constant: -20),
            buttonShare.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonShare.widthAnchor.constraint(equalTo: buttonRightNav.widthAnchor),
            buttonShare.heightAnchor.constraint(equalTo: buttonRightNav.heightAnchor),
            cartBadge.centerXAnchor.constraint(equalTo: buttonRightNav.trailingAnchor, constant: -2),
                cartBadge.centerYAnchor.constraint(equalTo: buttonRightNav.topAnchor, constant: 2),
                cartBadge.heightAnchor.constraint(equalToConstant: 20),
                cartBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
        
    }
    private func updateCartBadge() {

        APIService.shared.fetchCart { items in

            DispatchQueue.main.async {

                let total = items.reduce(0) { $0 + $1.1 }

                self.cartBadge.isHidden = total == 0
                self.cartBadge.text = total > 99 ? "99+" : "\(total)"
            }
        }
    }

    


    
    

    private func setupLayout() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor(named: "colorSecondary")

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: customNav.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // IMAGE
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onImageTap(_ :)))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])

        let buttonAdd = UIButton()
        buttonAdd.setImage(UIImage(named: "buttonAdd")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonAdd.tintColor = UIColor(named: "colorBg")
        buttonAdd.addTarget(self, action: #selector(onAddToCart(_ :)), for: .touchUpInside)
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(buttonAdd)
       
        
        let card = UIView()
        card.backgroundColor = UIColor(named: "colorWhite")
        card.layer.cornerRadius = 30
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -30),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            buttonAdd.topAnchor.constraint(equalTo: card.topAnchor, constant: -25),
            buttonAdd.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -30),
            buttonAdd.widthAnchor.constraint(equalToConstant: 50),
            buttonAdd.heightAnchor.constraint(equalToConstant: 50)
        ])

        setupCardContent(in: card)
    }
    
    private func setupCardContent(in card: UIView) {
        titleLabel.textColor = UIColor(named: "colorBlack")
        titleLabel.font = .boldSystemFont(ofSize: 24)
        priceLabel.font = .boldSystemFont(ofSize: 20)
        priceLabel.textColor = .systemRed

        ratingLabel.textColor = .systemOrange
        ratingLabel.font = .systemFont(ofSize: 18, weight: .medium)

        stockLabel.font = .systemFont(ofSize: 15, weight: .medium)
        stockLabel.textColor = UIColor(named: "colorDarkGreen")
        stockLabel.backgroundColor = UIColor(named: "colorGreen")?.withAlphaComponent(0.5)
        stockLabel.layer.cornerRadius = 12
        stockLabel.textAlignment = .center
        stockLabel.clipsToBounds = true
        stockLabel.setContentHuggingPriority(.required, for: .horizontal)
        stockLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        brandChip.font = .systemFont(ofSize: 16, weight: .medium)
        brandChip.textColor = UIColor(named: "colorBg")
        brandChip.backgroundColor = UIColor(named: "descColor")
        brandChip.layer.cornerRadius = 12
        brandChip.textAlignment = .center
        brandChip.clipsToBounds = true
        brandChip.numberOfLines = 1
        brandChip.setContentCompressionResistancePriority(.required, for: .horizontal)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = .systemFont(ofSize: 15)

        buttonAddtoFav.setTitle("Add to Favorites", for: .normal)
        buttonAddtoFav.backgroundColor = UIColor(named: "colorBg")
        buttonAddtoFav.layer.cornerRadius = 25
        buttonAddtoFav.addTarget(self, action: #selector(onAddToFav(_ :)), for: .touchUpInside)
        buttonAddtoFav.titleLabel?.font = .boldSystemFont(ofSize: 18)
        
        let priceStack = UIStackView(arrangedSubviews: [priceLabel, brandChip])
        priceStack.axis = .horizontal
        priceStack.spacing = 8
        priceStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        let ratingStockStack = UIStackView(arrangedSubviews: [ratingLabel, stockLabel])
        ratingStockStack.axis = .horizontal
        ratingStockStack.spacing = 12
        ratingStockStack.alignment = .center

       
        
        let mainStack = UIStackView(arrangedSubviews: [
            titleLabel,
            priceStack,
            ratingStockStack,
            descriptionLabel,
            buttonAddtoFav
        ])

        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(mainStack)

        NSLayoutConstraint.activate([
          
            mainStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 60),
            mainStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -40),
            buttonAddtoFav.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configure() {

        titleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        ratingLabel.text = "⭐️ \(product.rating)"
        stockLabel.text = product.stock > 0 ? "In Stock" : "Out of Stock"

        if let brand = product.brand {
            brandChip.text = "  \(brand)  "
        } else {
            brandChip.isHidden = true
        }

        descriptionLabel.text = product.description

        if let url = URL(string: product.images.first ?? "") {
            imageView.kf.setImage(with: url)
        }
    }
    
    private func updateButtonFav() {

        let isFav = FavoritesManager.shared.isFavorite(product.id)

        if isFav {
            buttonAddtoFav.setTitle("Remove from Favorites", for: .normal)
        } else {
            buttonAddtoFav.setTitle("Add to Favorites", for: .normal)
        }
    }

    

    
    
    @objc func onBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        if let tab = self.tabBarController as? CustomTabBarController {
            tab.setTabBarHidden(false)
        }
    }
    
    @objc func toBasket(_ sender: UIButton) {
        self.navigationController?.pushViewController(BasketController(), animated: true)
    }
    @objc func onImageTap(_ sender: UIButton) {
        let url = URL(string: product.images.first ?? "")!
        present(ImageViewerController(imageURL: url), animated: true)
    }
    
    
    @objc func onAddToFav(_ sender: UIButton) {

        FavoritesManager.shared.toggle(productId: product.id) {
            DispatchQueue.main.async {
                self.updateButtonFav()
            }
        }
    }

    
    @objc func onAddToCart(_ sender: UIButton) {

        APIService.shared.addToCart(productId: product.id) {

            APIService.shared.fetchCart { items in

                DispatchQueue.main.async {

                    let total = items.reduce(0) { $0 + $1.1 }

                    self.cartBadge.isHidden = total == 0
                    self.cartBadge.text = total > 99 ? "99+" : "\(total)"
                }
            }
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        FavoritesManager.shared.loadFavorites {
            self.updateButtonFav()
        }

        updateCartBadge()
    }



}

final class PaddingLabel: UILabel {

    var textInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }
}

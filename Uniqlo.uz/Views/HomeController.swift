//
//  ProfileVC.swift
//  CustomTabBar
//
//  Created by Hishara Dilshan on 2022-07-27.
//


import UIKit

class HomeController: UIViewController {
    
    let customNav = UIView()
    let productService = ProductService(network: NetworkService())
    let categoryView = CategoryView()
    let productView = ProductsView()
    private lazy var cartBadge = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor(named: "colorWhite")
        self.initCustomNav()
        self.initCategories()
        self.initProducts()
        
        Task {
            await loadCategories()
            await loadProducts()
        }
        categoryView.onCategorySelected = { [weak self] category in
            guard let self = self else { return }

            Task {
                if category.name == "All" {

                    let products = try await self.productService.getProducts(limit: 50, skip: 0)
                    self.productView.update(products: products)

                } else {

                    let products = try await self.productService.getProductsByCategory(category.name)
                    self.productView.update(products: products)
                    self.productView.scrollToTop()
                }
            }
        }
        
        productView.onProductSelected = { [weak self] product in
            let detail = ProductDetailController(product: product)
            self?.navigationController?.pushViewController(detail, animated: true)
            if let tab = self?.tabBarController as? CustomTabBarController {
                tab.setTabBarHidden(true)
            }
        }
        

        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateCartBadge()
        FavoritesManager.shared.loadFavorites {
            self.productView.reload()
        }
        

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
        
        customNav.backgroundColor = UIColor(named: "colorBg")
        customNav.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customNav)
        
        NSLayoutConstraint.activate([
            customNav.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            customNav.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            customNav.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            customNav.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2)
        ])
        
        
        let buttonLeftNav = UIButton()
        buttonLeftNav.setImage(UIImage(named: "logo"), for: .normal)
        buttonLeftNav.translatesAutoresizingMaskIntoConstraints = false
        customNav.addSubview(buttonLeftNav)
        
        let buttonRightNav = UIButton()
        buttonRightNav.setImage(UIImage(named: "buttonShopping")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonRightNav.tintColor = UIColor(named: "colorSecondary")
        buttonRightNav.addTarget(self, action: #selector(toBasket(_ :)), for: .touchUpInside)
        buttonRightNav.translatesAutoresizingMaskIntoConstraints = false
        customNav.addSubview(buttonRightNav)
        
        self.cartBadge = makeBadge()
        customNav.addSubview(cartBadge)
        NSLayoutConstraint.activate([
           
            
            buttonLeftNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonLeftNav.widthAnchor.constraint(equalTo: customNav.widthAnchor, multiplier: 0.4),
            buttonLeftNav.heightAnchor.constraint(equalTo: buttonLeftNav.widthAnchor),
            buttonLeftNav.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            
            buttonRightNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonRightNav.widthAnchor.constraint(equalToConstant: 30),
            buttonRightNav.heightAnchor.constraint(equalTo: buttonRightNav.widthAnchor),
            buttonRightNav.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
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

                    if total > 0 {
                        self.cartBadge.isHidden = false
                        self.cartBadge.text = total > 99 ? "99+" : "\(total)"
                    } else {
                        self.cartBadge.isHidden = true
                    }
            }
        }
    }
   
    private func initCategories() {
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(categoryView)
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: customNav.bottomAnchor, constant: 10),
            categoryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            categoryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func loadCategories() async {
        do {
            let categories = try await productService.getCategories()
            categoryView.update(categories: categories)

        } catch {
            print(error)
        }
        
    }
    
   




    
    
    private func initProducts() {
        productView.translatesAutoresizingMaskIntoConstraints = false
        productView.backgroundColor = UIColor(named: "colorSecondary")
        self.view.addSubview(productView)
        NSLayoutConstraint.activate([
            productView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 10),
            productView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func loadProducts() async {
        do {
            let products = try await productService.getProducts(limit: 50, skip: 0)
            ProductStore.shared.allProducts = products
            productView.update(products: products)

        } catch {
            print(error)
        }
    }
    
    

    
    
    @objc func toBasket(_ sender: UIButton) {

        if let tab = self.tabBarController as? CustomTabBarController {
            tab.setTabBarHidden(true)
        }

        self.navigationController?.pushViewController(BasketController(), animated: true)
    }

    
    
}




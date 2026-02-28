//
//  BasketController.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 14/02/26.
//

import UIKit

class BasketController: UIViewController {
    
    private let customNav = UIView()
    private let tableView = UITableView()
    private let cardBill = UIView()
    private var subtotalValueLabel = UILabel()
    private var deliveryValueLabel = UILabel()
    private var totalValueLabel = UILabel()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "colorSecondary")
        self.navigationController?.isNavigationBarHidden = true
        self.initCustomNav()
        self.initBill()
        self.initBasketTable()
        
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
        buttonLeftNav.setImage(UIImage(named: "buttonBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonLeftNav.tintColor = UIColor(named: "colorWhite")
        buttonLeftNav.addTarget(self, action: #selector(onBack(_ :)), for: .touchUpInside)
        buttonLeftNav.translatesAutoresizingMaskIntoConstraints = false
        customNav.addSubview(buttonLeftNav)
        
        
        
        
       
        let labelNav = UILabel()
        labelNav.text = "My Basket"
        labelNav.textColor = UIColor(named: "colorWhite")
        labelNav.font = .systemFont(ofSize: 22, weight: .bold)
        labelNav.translatesAutoresizingMaskIntoConstraints = false
        customNav.addSubview(labelNav)
        
        
        
        
        let buttonRightNav = UIButton()
        buttonRightNav.setImage(UIImage(named: "buttonBin")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonRightNav.tintColor = UIColor(named: "colorSecondary")
        buttonRightNav.addTarget(self, action: #selector(onDelete(_ :)), for: .touchUpInside)
        buttonRightNav.translatesAutoresizingMaskIntoConstraints = false
        customNav.addSubview(buttonRightNav)

        NSLayoutConstraint.activate([
            
            
            
            buttonLeftNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonLeftNav.widthAnchor.constraint(equalTo: customNav.heightAnchor, multiplier: 0.35),
            buttonLeftNav.heightAnchor.constraint(equalTo: buttonLeftNav.widthAnchor),
            buttonLeftNav.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            labelNav.centerXAnchor.constraint(equalTo: customNav.centerXAnchor),
            labelNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            labelNav.heightAnchor.constraint(equalTo: customNav.heightAnchor),
            labelNav.widthAnchor.constraint(equalTo: customNav.widthAnchor, multiplier: 0.4),
            
            buttonRightNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonRightNav.widthAnchor.constraint(equalTo: buttonLeftNav.widthAnchor),
            buttonRightNav.heightAnchor.constraint(equalTo: buttonLeftNav.heightAnchor),
            buttonRightNav.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
    }
    
    func initBasketTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "colorSecondary")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BasketCell.self, forCellReuseIdentifier: BasketCell.basketID)
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: customNav.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: cardBill.topAnchor)
         ])
    }
    private func makeRow(title: String) -> (UIStackView, UILabel) {

        let left = UILabel()
        left.text = title
        left.textColor = .systemGray
        left.font = .systemFont(ofSize: 16)

        let right = UILabel()
        right.textColor = UIColor(named: "colorBlack")
        right.font = .systemFont(ofSize: 16, weight: .medium)
        right.textAlignment = .right

        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing

        return (stack, right)
    }

    
    private func makeTotalRow() -> (UIStackView, UILabel) {
        
        let left = UILabel()
        left.text = "Total:"
        left.textColor = UIColor(named: "colorBlack")
        left.font = .boldSystemFont(ofSize: 20)

        let right = UILabel()
        right.textColor = UIColor(named: "colorBlack")
        right.font = .boldSystemFont(ofSize: 20)
        right.textAlignment = .right

        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        return (stack, right)
    }


    func initBill() {

        
        cardBill.backgroundColor = UIColor(named: "colorWhite")
        cardBill.layer.cornerRadius = 20
        cardBill.layer.borderWidth = 0.4
        cardBill.layer.borderColor = UIColor(named: "colorBg")?.cgColor
        cardBill.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardBill)

        NSLayoutConstraint.activate([
            cardBill.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardBill.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardBill.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])

        let (subtotalRow, subtotalLabel) = makeRow(title: "Subtotal:")
        let (deliveryRow, deliveryLabel) = makeRow(title: "Delivery:")
        let (totalRow, totalLabel) = makeTotalRow()

        subtotalValueLabel = subtotalLabel
        deliveryValueLabel = deliveryLabel
        totalValueLabel = totalLabel


        let divider = UIView()
        divider.backgroundColor = .systemGray4
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let buttonBill = UIButton()
        buttonBill.setTitle("Proceed to checkout", for: .normal)
        buttonBill.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        buttonBill.setTitleColor(UIColor(named: "colorWhite"), for: .normal)
        buttonBill.backgroundColor = UIColor(named: "colorBg")
        buttonBill.layer.cornerRadius = 10
        buttonBill.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let mainStack = UIStackView(arrangedSubviews: [
            subtotalRow,
            deliveryRow,
            divider,
            totalRow,
            buttonBill
        ])

        mainStack.axis = .vertical
        mainStack.spacing = 15
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        cardBill.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: cardBill.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: cardBill.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: cardBill.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: cardBill.bottomAnchor, constant: -20)
        ])
    }

    private func updateBill() {

        let subtotal = BasketManager.shared.subtotal
        let delivery = BasketManager.shared.delivery
        let total = BasketManager.shared.total

        subtotalValueLabel.text = String(format: "$%.2f", subtotal)
        deliveryValueLabel.text = delivery == 0 ? "Free" : String(format: "$%.2f", delivery)
        totalValueLabel.text = String(format: "$%.2f", total)
    }
    
    private func fetchCart() {
        print("Fetching cart from backend...")
        APIService.shared.fetchCart { items in

            DispatchQueue.main.async {

                BasketManager.shared.items.removeAll()

                for (productId, quantity) in items {

                    if let product = ProductStore.shared.product(with: productId) {

                        for _ in 0..<quantity {
                            BasketManager.shared.add(product)
                        }
                    }
                }

                self.tableView.reloadData()
                self.updateBill()
            }
        }
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCart()
        tableView.reloadData()
        updateBill()
    }
    
    @objc func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        if let tab = self.tabBarController as? CustomTabBarController {
            tab.setTabBarHidden(false)
        }
    }
    @objc func onDelete(_ sender: UIButton) {

        let alert = UIAlertController(
            title: "Remove all products",
            message: "Do you want to remove all products from basket?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Remove All", style: .destructive) { _ in

            APIService.shared.deleteAllCart {

                DispatchQueue.main.async {
                    BasketManager.shared.removeAll()
                    self.tableView.reloadData()
                    self.updateBill()
                }
            }
        })

        self.present(alert, animated: true)
    }

}


extension BasketController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return BasketManager.shared.items.count
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: BasketCell.basketID,
            for: indexPath
        ) as! BasketCell

        
        let item = BasketManager.shared.items[indexPath.section]
        cell.configure(with: item)
        cell.onQuantityChanged = { newCount in

            APIService.shared.updateCart(productId: item.product.id, quantity: newCount) {

                DispatchQueue.main.async {
                    BasketManager.shared.updateQuantity(for: item.product, quantity: newCount)
                    self.updateBill()
                }
            }
        }
        
        cell.onAddedToFav = { [weak self] in
            guard let self = self else { return }
            APIService.shared.addFavorite(productId: item.product.id) {
                DispatchQueue.main.async {
                    print("Added to favorites:", item.product.id)
                   
                }
            }
        }
        
        cell.onImageTap = { [weak self] in
            guard let self = self else { return }
            let detailController = ProductDetailController(product: item.product)
            self.navigationController?.pushViewController(detailController, animated: true)
        }
        
        cell.onRemoveRequest = { [weak self] in
            guard let self = self else { return }

            let alert = UIAlertController(
                title: "Remove product",
                message: "Do you want to remove this product from basket?",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in

                APIService.shared.deleteFromCart(productId: item.product.id) {

                    DispatchQueue.main.async {
                        BasketManager.shared.remove(item.product)
                        self.tableView.reloadData()
                        self.updateBill()
                    }
                }
            })

            self.present(alert, animated: true)
        }

        return cell
    }
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

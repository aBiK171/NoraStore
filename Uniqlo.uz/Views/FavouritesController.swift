//
//  FavouritesVC.swift
//  CustomTabBar
//
//  Created by Hishara Dilshan on 2022-07-27.
//

import UIKit

class FavouritesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let customNav = UIView()
    private let tableView = UITableView()
    var products: [Product] {
        FavoritesManager.shared.favoriteIds.compactMap { id in
            ProductStore.shared.allProducts.first(where: { $0.id == id })
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "colorWhite")
        self.initCustomNav()
        self.initFavTable()
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        FavoritesManager.shared.loadFavorites {
            self.tableView.reloadData()
        }
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
        buttonLeftNav.setImage(UIImage(named: "logoFav"), for: .normal)
        buttonLeftNav.translatesAutoresizingMaskIntoConstraints = false
        customNav.addSubview(buttonLeftNav)
        
        let buttonRightNav = UIButton()
        buttonRightNav.setImage(UIImage(named: "buttonBin")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonRightNav.addTarget(self, action: #selector(onReset(_ :)), for: .touchUpInside)
        buttonRightNav.tintColor = UIColor(named: "colorSecondary")
        buttonRightNav.translatesAutoresizingMaskIntoConstraints = false
        customNav.addSubview(buttonRightNav)
        
        
        NSLayoutConstraint.activate([
            
            
            buttonLeftNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonLeftNav.widthAnchor.constraint(equalTo: customNav.widthAnchor, multiplier: 0.4),
            buttonLeftNav.heightAnchor.constraint(equalTo: buttonLeftNav.widthAnchor),
            buttonLeftNav.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            
            buttonRightNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonRightNav.widthAnchor.constraint(equalToConstant: 25),
            buttonRightNav.heightAnchor.constraint(equalTo: buttonRightNav.widthAnchor),
            buttonRightNav.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
    }
    
    func initFavTable() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor(named: "colorBg")
        tableView.register(FavCell.self, forCellReuseIdentifier: FavCell.favID)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: customNav.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count

    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: FavCell.favID) as! FavCell
        let product = products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        let detail = ProductDetailController(product: product)
        self.navigationController?.pushViewController(detail, animated: true)
        if let tab = self.tabBarController as? CustomTabBarController {
            tab.setTabBarHidden(true)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let product = products[indexPath.row]

        let delete = UIContextualAction(style: .destructive, title: "Delete") { _,_,completion in

            FavoritesManager.shared.toggle(productId: product.id) {

                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    completion(true)
                }
            }
        }

        return UISwipeActionsConfiguration(actions: [delete])
    }


    
    
    
    @objc func onReset(_ sender: UIButton) {

        let alert = UIAlertController(
            title: "Reset",
            message: "Are you sure you want to reset your favorites?",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in

            FavoritesManager.shared.removeAll {
                self.tableView.reloadData()
            }
        }


        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        present(alert, animated: true)
    }

    
}

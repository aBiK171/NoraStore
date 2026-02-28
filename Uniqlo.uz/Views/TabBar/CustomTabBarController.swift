//
//  CustomTabBarVC.swift
//  CustomTabBar
//
//  Created by Hishara Dilshan on 2022-07-27.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    private let profileTab = CustomTabBarItem(
        index: 0,
        title: "Home",
        icon: UIImage(systemName: "house.circle")?.withTintColor(UIColor.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal),
        selectedIcon: UIImage(systemName: "house.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal),
        viewController: UINavigationController(rootViewController: HomeController()))
    
    private let searchTab = CustomTabBarItem(
        index: 1,
        title: "Search",
        icon: UIImage(systemName: "magnifyingglass.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal),
        selectedIcon: UIImage(systemName: "magnifyingglass.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal),
        viewController: UINavigationController(rootViewController: SearchViewController()))
    
    private let favouriteTab = CustomTabBarItem(
        index: 2,
        title: "Favourites",
        icon: UIImage(systemName: "heart.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal),
        selectedIcon: UIImage(systemName: "heart.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal),
        viewController: UINavigationController(rootViewController: FavouritesController()))
    
    private let settingsTab = CustomTabBarItem(
        index: 3,
        title: "Settings",
        icon: UIImage(systemName: "gearshape.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal),
        selectedIcon: UIImage(systemName: "gearshape.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal),
        viewController: UINavigationController(rootViewController: SettingsController()))
    
    private lazy var tabBarTabs: [CustomTabBarItem] = [profileTab, searchTab, favouriteTab, settingsTab]
    
    private var customTabBar: CustomTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        setupHierarchy()
        setupLayoutConstraints()
        setupProperties()
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupCustomTabBar() {
        self.customTabBar = CustomTabBar(tabBarTabs: tabBarTabs, onTabSelected: { [weak self] index in
            self?.selectTabWith(index: index)
        })
    }
    
    private func setupHierarchy() {
        view.addSubview(customTabBar)
    }
    
    private func setupLayoutConstraints() {
        customTabBar.anchor(left: view.safeAreaLayoutGuide.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor,
                            paddingLeft: 25,
                            paddingRight: 25,
                            height: 90)
    }
    
    private func setupProperties() {
        tabBar.isHidden = true
        customTabBar.addShadow()
        
        self.selectedIndex = 0
        let controllers = tabBarTabs.map { item in
            return item.viewController
        }
        self.setViewControllers(controllers, animated: true)
    }
    
    private func selectTabWith(index: Int) {
        self.selectedIndex = index
    }
    
    func setTabBarHidden(_ hidden: Bool) {
        customTabBar.isHidden = hidden
    }

}

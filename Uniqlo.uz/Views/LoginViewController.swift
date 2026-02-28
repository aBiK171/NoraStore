//
//  LoginViewController.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 16/02/26.
//

import UIKit

class LoginViewController: UIViewController {
    
    let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        let stack = UIStackView(arrangedSubviews: [usernameField, passwordField, loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    
    
    
    

    
    
    
    @objc func loginTapped() {
        self.navigationController?.pushViewController(CustomTabBarController(), animated: true)
        
       
    }
}

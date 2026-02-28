//
//  SignIN.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 17/02/26.
//

import UIKit

class SignInController: UIViewController, UIScrollViewDelegate {
    
    let usernameField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor(named: "colorBlack")
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.keyboardType = .asciiCapable
        tf.backgroundColor = UIColor(named: "colorWhite")
        return tf
    }()
    
    
    let passwordField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor(named: "colorBlack")
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(named: "colorWhite")
        return tf
    }()
    

    
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = UIColor(named: "colorBg")
        btn.setTitleColor(UIColor(named: "colorWhite"), for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(onLoginTapped(_ :)), for: .touchUpInside)
        btn.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        return btn
    }()
    
    let badgeState: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let buttonSignIn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "colorSecondary")
        self.navigationController?.isNavigationBarHidden = true
        self.setupScrollView()
        self.setupNav()
        self.setupUI()
    }
    
    private func setupScrollView() {
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func setupNav() {
        
        buttonSignIn.setTitle("Sign Up", for: .normal)
        buttonSignIn.setTitleColor(UIColor(named: "colorGray"), for: .normal)
        buttonSignIn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        buttonSignIn.addTarget(self, action: #selector(onSignUpTapped(_ :)), for: .touchUpInside)
        buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonSignIn)
        
        NSLayoutConstraint.activate([
            buttonSignIn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            buttonSignIn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupUI() {
        let labelTitle = UILabel()
        labelTitle.text = "Sign In"
        labelTitle.textColor = UIColor(named: "colorBg")
        labelTitle.font = .systemFont(ofSize: 28, weight: .black)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelTitle)
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: buttonSignIn.bottomAnchor, constant: 50),
            labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        usernameField.setPlaceholder("Username", color: UIColor(named: "colorGray")!)
        passwordField.setPlaceholder("Password", color: UIColor(named: "colorGray")!)
        
        let stack = UIStackView(arrangedSubviews: [usernameField, passwordField, loginButton, badgeState])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 40),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            usernameField.heightAnchor.constraint(equalToConstant: 40),
            passwordField.heightAnchor.constraint(equalTo: self.usernameField.heightAnchor),
            loginButton.heightAnchor.constraint(equalTo: self.usernameField.heightAnchor, constant: 10),
            
            
        ])
        
    }
    
    
    
    @objc func onSignUpTapped(_ sender: UIButton) {
        let signUp = SignUpController()
        navigationController?.pushViewController(signUp, animated: true)
    }
    
    
    @objc func onLoginTapped(_ sender: UIButton) {

        guard let username = usernameField.text,
              let password = passwordField.text else { return }

        APIService.shared.login(username: username,
                                password: password) { success in

            DispatchQueue.main.async {

                if success {
                    let home = CustomTabBarController()
                    UIApplication.shared.connectedScenes
                        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                        .first?
                        .rootViewController = home
                    let tab = self.tabBarController as? CustomTabBarController
                    tab?.setTabBarHidden(false)
                
                } else {
                    self.badgeState.text = "This account doesn't exist"
                    print("Login failed")
                }
            }
        }
    }

}
extension UITextField {

    func setPlaceholder(_ text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: color]
        )
    }
}

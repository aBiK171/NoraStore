//
//  SignUP.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 17/02/26.
//

import UIKit

class SignUpController: UIViewController, UIScrollViewDelegate {
    
    let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.textColor = UIColor(named: "colorBlack")
        tf.backgroundColor = UIColor(named: "colorWhite")
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.keyboardType = .asciiCapable
        return tf
    }()
    
    let nameField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor(named: "colorBlack")
        tf.backgroundColor = UIColor(named: "colorWhite")
        tf.placeholder = "Name"
        tf.borderStyle = .roundedRect
       
        return tf
    }()
    
    let passwordField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor(named: "colorBlack")
        tf.backgroundColor = UIColor(named: "colorWhite")
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let confirmPassword: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor(named: "colorBlack")
        tf.backgroundColor = UIColor(named: "colorWhite")
        tf.placeholder = "Confirm password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

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
        
        buttonSignIn.setTitle("Sign In", for: .normal)
        buttonSignIn.setTitleColor(UIColor(named: "colorGray"), for: .normal)
        buttonSignIn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        buttonSignIn.addTarget(self, action: #selector(onSignInTapped(_ :)), for: .touchUpInside)
        buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonSignIn)
        
        NSLayoutConstraint.activate([
            buttonSignIn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            buttonSignIn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupUI() {
        let labelTitle = UILabel()
        labelTitle.text = "Sign Up"
        labelTitle.textColor = UIColor(named: "colorBg")
        labelTitle.font = .systemFont(ofSize: 28, weight: .black)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelTitle)
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: buttonSignIn.bottomAnchor, constant: 40),
            labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        nameField.setPlaceholder("Name", color: UIColor(named: "colorGray")!)
        usernameField.setPlaceholder("Username", color: UIColor(named: "colorGray")!)
        passwordField.setPlaceholder("Password", color: UIColor(named: "colorGray")!)
        confirmPassword.setPlaceholder("Confirm Password", color: UIColor(named: "colorGray")!)
        
        
        let stack = UIStackView(arrangedSubviews: [nameField, usernameField, passwordField, confirmPassword, loginButton, badgeState])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 40),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            nameField.heightAnchor.constraint(equalToConstant: 40),
            usernameField.heightAnchor.constraint(equalTo: self.nameField.heightAnchor),
            passwordField.heightAnchor.constraint(equalTo: self.nameField.heightAnchor),
            confirmPassword.heightAnchor.constraint(equalTo: self.nameField.heightAnchor),
            
            loginButton.heightAnchor.constraint(equalTo: self.nameField.heightAnchor, constant: 10)
            
            
            
        ])
        
    }
    
    
    
    @objc private func keyboardWillShow(notification: Notification) {

        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height

        scrollView.contentInset.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets.bottom = keyboardHeight
    }

    @objc private func keyboardWillHide(notification: Notification) {

        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }

    
    @objc func onSignInTapped(_ sender: UIButton) {
        let signIn = SignInController()
        navigationController?.pushViewController(signIn, animated: true)
    }
    
    @objc func onLoginTapped(_ sender: UIButton) {

        guard let username = usernameField.text,
              let password = passwordField.text,
              let name = nameField.text else { return }

        APIService.shared.signup(username: username,
                                 password: password,
                                 name: name) { success in

            DispatchQueue.main.async {

                if success {
                    let home = CustomTabBarController()
                    self.navigationController?.setViewControllers([home], animated: true)
                } else {
                    self.badgeState.text = "This account already exists"
                    print("Signup error")
                }

            }
        }
    }


}

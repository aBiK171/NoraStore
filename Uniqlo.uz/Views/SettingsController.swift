//
//  ProfileViewController.swift
//  profile_settings
//
//  Created by Abboskhon Rakhimov on 26/09/25.
//

import UIKit

class SettingsController : UIViewController {
    var buttonSettings : UIButton!
    var labelEmail: UILabel!
    var labelSection: UILabel!
    var imageIcon : UIImageView!
    var iconRow : UIImageView!
    var titleLabel : UILabel!
    private let customNav = UIView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
    private var rows: [SettingsRow] = [
            SettingsRow(icon: UIImage(named: "buttonUser"), title: "Username", subtitle: "@your_username", type: .username),
            SettingsRow(icon: UIImage(named: "notifications"), title: "Notifications", subtitle: "Mute, Push, Email", type: .notifications),
            SettingsRow(icon: UIImage(named: "languages"), title: "Languages", subtitle: "English", type: .language)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor(named: "colorWhite")
        self.initCustomNav()
        self.initHeader()
        self.initTable()
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
        buttonRightNav.setImage(UIImage(named: "user")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonRightNav.addTarget(self, action: #selector(onLogin(_ :)), for: .touchUpInside)
        buttonRightNav.tintColor = UIColor(named: "colorSecondary")
        buttonRightNav.translatesAutoresizingMaskIntoConstraints = false
        customNav.addSubview(buttonRightNav)
        
        
        NSLayoutConstraint.activate([
            
            
            buttonLeftNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonLeftNav.widthAnchor.constraint(equalTo: customNav.widthAnchor, multiplier: 0.4),
            buttonLeftNav.heightAnchor.constraint(equalTo: buttonLeftNav.widthAnchor),
            buttonLeftNav.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            
            buttonRightNav.centerYAnchor.constraint(equalTo: customNav.centerYAnchor),
            buttonRightNav.widthAnchor.constraint(equalToConstant: 40),
            buttonRightNav.heightAnchor.constraint(equalTo: buttonRightNav.widthAnchor),
            buttonRightNav.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
    }
   
    
    
    func initHeader() {
        let imageHeader = UIImageView(image: UIImage(named: "buttonUser"))
        imageHeader.contentMode = .scaleAspectFill
        imageHeader.layer.cornerRadius = 50
        imageHeader.layer.borderWidth = 0.5
        imageHeader.layer.borderColor = UIColor.label.cgColor
        imageHeader.clipsToBounds = true
        imageHeader.backgroundColor = UIColor(named: "colorWhite")
        
        imageHeader.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageHeader)
        
        NSLayoutConstraint.activate([
            imageHeader.topAnchor.constraint(equalTo: customNav.bottomAnchor, constant: 20),
            imageHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageHeader.widthAnchor.constraint(equalToConstant: 100),
            imageHeader.heightAnchor.constraint(equalTo: imageHeader.widthAnchor)
        ])
        
        
        let labelName = UILabel()
        labelName.text = "Unknown User"
        labelName.font = .boldSystemFont(ofSize: 28)
        labelName.textColor = UIColor(named: "colorBg")
        labelName.numberOfLines = 1
        labelName.textAlignment = .center
        labelName.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(labelName)
        
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: imageHeader.bottomAnchor, constant: 30),
            labelName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        
        labelEmail = UILabel()
        labelEmail.text = "qwerty123@gmail.com"
        labelEmail.font = .boldSystemFont(ofSize: 22)
        labelEmail.textColor = .systemGray2
        labelEmail.numberOfLines = 1
        labelEmail.textAlignment = .center
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(labelEmail)
        
        NSLayoutConstraint.activate([
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 10),
            labelEmail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          
        ])
        
    }

    
    private func initTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor(named: "colorBg")
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    @objc func onLogin(_ sender: UIButton) {
        let loginVC = LoginViewController()
        
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc func chooseLang(_ sender: UITapGestureRecognizer) {
        let languageModal = LanguageSelectionModal()
        languageModal.onSelectedLanguage = { model in
            self.updateUI(model)
        }
        
        languageModal.modalPresentationStyle = .custom
        languageModal.modalTransitionStyle = .partialCurl
        self.present(languageModal, animated: true)
    }
    
    func updateUI(_ model: LanguageItemModel) {
        self.iconRow.image = model.image
        self.titleLabel.text = model.title
    }
    
}

extension SettingsController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsCell.identifier,
            for: indexPath
        ) as! SettingsCell
        
        cell.configure(with: rows[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let row = rows[indexPath.row]
        
        switch row.type {
        case .language:
            let modal = LanguageSelectionModal()
            
            modal.onSelectedLanguage = { [weak self] model in
                self?.rows[indexPath.row] = SettingsRow(
                    icon: model.image,
                    title: "Languages",
                    subtitle: model.title,
                    type: .language
                )
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            modal.modalPresentationStyle = .overFullScreen
            present(modal, animated: true)
            
        default:
            break
        }
    }
}

    


    
    
    
    
    
    
    
    
    
    


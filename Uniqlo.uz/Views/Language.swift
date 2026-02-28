//
//  Language.swift
//  profile_settings
//
//  Created by Abboskhon Rakhimov on 26/09/25.
//

import UIKit

enum LanguageItem {
    case english
    case russian
    case uzbek
    case cyrilic
    
    var title: String{
        switch self {
        case .english:
            return "English"
        case .russian:
            return "Русский язык"
        case .uzbek:
            return "Uzbek tili"
        case .cyrilic:
            return "Узбек тили"
        }
    }
}

struct LanguageItemModel {
    var type: LanguageItem
    var title: String{
        return type.title
    }
    var image: UIImage? {
        switch self.type {
        case.english:
            return UIImage(named: "english")
        case.russian:
            return UIImage(named: "russia")
        case.uzbek:
            return UIImage(named: "uzbek")
        case.cyrilic:
            return UIImage(named: "uzbek")
        }
    }
}

class LanguageSelectionModal : UIViewController {
    
    var onSelectedLanguage: ((LanguageItemModel) -> Void)?
    
    private var languageModels : [LanguageItemModel] = [
        LanguageItemModel(type: .english),
        LanguageItemModel(type: .russian),
        LanguageItemModel(type: .uzbek),
        LanguageItemModel(type: .cyrilic)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        
        let containerView = UIView()
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = UIColor(named: "colorWhite")
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        ])
        let buttonClose = UIButton()
        buttonClose.setImage(UIImage(named: "close"), for: .normal)
        buttonClose.tintColor = .label
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        buttonClose.contentMode = .scaleAspectFill
        buttonClose.addTarget(self, action: #selector(closeModal(_ :)), for: .touchUpInside)
        containerView.addSubview(buttonClose)
        
        NSLayoutConstraint.activate([
            buttonClose.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            buttonClose.widthAnchor.constraint(equalToConstant: 30),
            buttonClose.heightAnchor.constraint(equalToConstant: 30),
            buttonClose.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
        
        for i in 0 ... 3 {
            let languageItemView = LanguageItemView(model: self.languageModels[i])
            languageItemView.onItemSelected = { model in
                self.dismissWith(model: model)
            }
            languageItemView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(languageItemView)
            
            NSLayoutConstraint.activate([
                languageItemView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
                languageItemView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0),
                languageItemView.heightAnchor.constraint(equalToConstant: 50),
                languageItemView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20 + 50 * CGFloat(i))
            ])
        }
    }
    @objc func closeModal(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    func dismissWith(model: LanguageItemModel) {
        print(model.title)
        self.onSelectedLanguage?(model)
        self.dismiss(animated: true)
    }
}


class LanguageItemView : UIView {
    
    var onItemSelected: ((LanguageItemModel) -> Void)?
    
    var model: LanguageItemModel!
    var labelTitle: UILabel!
    var imageIcon: UIImageView!
    
    init(model: LanguageItemModel){
        super.init(frame: .zero)
        self.model = model
        self.isUserInteractionEnabled = true
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onItem(_ :))))
    }
    
    override func layoutSubviews() {
        self.initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        imageIcon = UIImageView()
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        imageIcon.image = self.model.image
        self.addSubview(imageIcon)
        
        
        labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.numberOfLines = 1
        labelTitle.font = .systemFont(ofSize: 17, weight: .regular)
        labelTitle.textColor = .black
        labelTitle.contentMode = .center
        labelTitle.textAlignment = .left
        labelTitle.text = self.model.title
        self.addSubview(labelTitle)
        
        NSLayoutConstraint.activate([
            imageIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            imageIcon.widthAnchor.constraint(equalToConstant: 24),
            imageIcon.heightAnchor.constraint(equalTo: imageIcon.widthAnchor),
            imageIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            
            labelTitle.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: 16),
            labelTitle.heightAnchor.constraint(equalToConstant: 50),
            labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
            
        ])
    }
    
    @objc func onItem(_ sender: UIView) {
        self.onItemSelected?(self.model)
    }
}

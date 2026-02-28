//
//  SettingsCell.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 14/02/26.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    static let identifier = "SettingsCell"
    
    private let iconImage = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .default
        
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.contentMode = .scaleAspectFit
        
        titleLabel.textColor = UIColor(named: "colorBlack")
        titleLabel.font = .boldSystemFont(ofSize: 17)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray
        
        arrow.tintColor = .systemGray
        
        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 4
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView(arrangedSubviews: [iconImage, labelsStack, UIView(), arrow])
        mainStack.axis = .horizontal
        mainStack.spacing = 16
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            iconImage.widthAnchor.constraint(equalToConstant: 28),
            iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with row: SettingsRow) {
        iconImage.image = row.icon
        titleLabel.text = row.title
        subtitleLabel.text = row.subtitle
    }
}

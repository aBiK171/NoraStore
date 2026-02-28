//
//  CategoryCell.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 11/02/26.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    static let categoryID = "CategoryID"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 20
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
               titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(category: Category) {
        titleLabel.text = category.name
        
        if category.isSelected {
            contentView.backgroundColor = UIColor(named: "colorBg")
            titleLabel.textColor = UIColor(named: "colorWhite")
        } else {
            contentView.backgroundColor = UIColor(named: "colorSecondary")
            titleLabel.textColor = UIColor(named: "colorBlack")
        }
    }
}

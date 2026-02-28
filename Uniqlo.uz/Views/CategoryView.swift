//
//  CategoryView.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 11/02/26.
//

import UIKit

class CategoryView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var categoriesCollection: UICollectionView!
    private var categories: [Category] = []
    var onCategorySelected: ((Category) -> Void)?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollection(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        
        categoriesCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoriesCollection.backgroundColor = .clear
        categoriesCollection.showsHorizontalScrollIndicator = false
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        categoriesCollection.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.categoryID)
        categoriesCollection.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(categoriesCollection)
        
       

        NSLayoutConstraint.activate([
            categoriesCollection.topAnchor.constraint(equalTo: self.topAnchor),
            categoriesCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            categoriesCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            categoriesCollection.heightAnchor.constraint(equalToConstant: 70),
        ])

    }
    
    func update(categories: [Category]) {
        self.categories = categories
        categoriesCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCell.categoryID,
            for: indexPath
        ) as! CategoryCell
        let category = categories[indexPath.row]
        cell.configure(category: category)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        for i in 0..<categories.count {
            categories[i].isSelected = false
        }

        categories[indexPath.row].isSelected = true

        categoriesCollection.reloadData()

        let selectedCategory = categories[indexPath.row]
        onCategorySelected?(selectedCategory)
    }



}

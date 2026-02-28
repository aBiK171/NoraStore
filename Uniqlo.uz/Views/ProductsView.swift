    //
    //  ProductsView.swift
    //  Uniqlo.uz
    //
    //  Created by Abboskhon Rakhimov on 11/02/26.
    //

import UIKit
class ProductsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
       
        
    var onLikeTapped: ((Product) -> Void)?
    private var productsCollect: UICollectionView!
    private var products: [Product] = []
    var onProductSelected: ((Product) -> Void)?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCollection()
        
        
    }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    
        private func setupCollection(){
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)



            
            productsCollect = UICollectionView(frame: .zero, collectionViewLayout: layout)
            productsCollect.backgroundColor = .clear
            productsCollect.showsVerticalScrollIndicator = false
            productsCollect.delegate = self
            productsCollect.dataSource = self
            productsCollect.register(ProductsCell.self, forCellWithReuseIdentifier: ProductsCell.productID)
            productsCollect.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(productsCollect)
            
           

            NSLayoutConstraint.activate([
                productsCollect.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                productsCollect.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                productsCollect.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                productsCollect.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])

        }
    func scrollToTop() {
        if products.count > 0 {
            productsCollect.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    func reload() {
        productsCollect.reloadData()
    }

    
    func update(products: [Product]) {
        self.products = products
        productsCollect.reloadData()
    }

        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            self.products.count
        }
        
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductsCell.productID,
            for: indexPath
        ) as! ProductsCell

        let product = products[indexPath.row]
        cell.configure(with: product)

        cell.onLikeTapped = { [weak self] in
            guard let self = self else { return }

            FavoritesManager.shared.toggle(productId: product.id) {
                self.productsCollect.reloadItems(at: [indexPath])
            }
        }



        return cell
    }


        
    func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {

        let padding: CGFloat = 16 * 3
        let availableWidth = collectionView.frame.width - padding
        let width = availableWidth / 2
        return CGSize(width: width, height: width * 1.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        onProductSelected?(product)
        
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

}

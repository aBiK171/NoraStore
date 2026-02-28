//
//  ProductStore.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 17/02/26.
//

final class ProductStore {

    static let shared = ProductStore()
    private init() {}

    var allProducts: [Product] = []

    func product(with id: Int) -> Product? {
        return allProducts.first { $0.id == id }
    }
}

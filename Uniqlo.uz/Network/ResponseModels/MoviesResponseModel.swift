
import Foundation


struct ProductsResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let rating: Double
    let stock: Int
    let brand: String?
    let images: [String]
    let thumbnail: String
}
struct Category {
    let name: String
    var isSelected: Bool
}


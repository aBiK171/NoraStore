protocol ProductServiceProtocol {
    func getProducts(limit: Int, skip: Int) async throws -> [Product]
    func getCategories() async throws -> [Category]
    func getProductsByCategory(_ category: String) async throws -> [Product]
    func searchProducts(_ query: String) async throws -> [Product]
}


final class ProductService: ProductServiceProtocol {
    
    

    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func getProducts(limit: Int, skip: Int) async throws -> [Product] {
        let response: ProductsResponse = try await network.request(
            APIRouter.getProducts(limit: limit, skip: skip)
        )
        return response.products
    }

    func getCategories() async throws -> [Category] {
        let response: [String] = try await network.request(APIRouter.getCategories)

        var categories = response.map {
            Category(name: $0, isSelected: false)
        }


        categories.insert(Category(name: "All", isSelected: true), at: 0)

        return categories
    }




    func getProductsByCategory(_ category: String) async throws -> [Product] {
        let response: ProductsResponse = try await network.request(
            APIRouter.getProductsByCategory(category: category)
        )
        return response.products
    }
    
    func searchProducts(_ query: String) async throws -> [Product] {
        let response: ProductsResponse = try await network.request(
            APIRouter.searchProducts(query: query)
        )
        return response.products
    }
}


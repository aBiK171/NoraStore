final class BasketManager {

    static let shared = BasketManager()
    private init() {}

    struct BasketItem {
        var product: Product
        var quantity: Int
    }

    var items: [BasketItem] = []


    func add(_ product: Product) {

        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            let newItem = BasketItem(product: product, quantity: 1)
            items.append(newItem)
        }
    }
    
    
    
    // MARK: Update quantity

    func updateQuantity(for product: Product, quantity: Int) {

        guard let index = items.firstIndex(where: { $0.product.id == product.id }) else { return }

        items[index].quantity = quantity
    }
    func quantity(for product: Product) -> Int {
        return items.first(where: { $0.product.id == product.id })?.quantity ?? 0
    }


    // MARK: Remove

    func removeAll() {
        items.removeAll()
    }
    func remove(_ product: Product) {
        items.removeAll(where: { $0.product.id == product.id })
    }
    
    var count: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
    
    var subtotal: Double {
        return items.reduce(0) { result, item in
            result + (item.product.price * Double(item.quantity))
        }
    }

    var delivery: Double {
        return subtotal > 0 ? 0 : 0
    }

    var total: Double {
        return subtotal + delivery
    }
}

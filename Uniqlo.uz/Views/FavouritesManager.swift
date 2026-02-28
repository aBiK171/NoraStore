import Foundation

class FavoritesManager {

    static let shared = FavoritesManager()
    private init() {}

    private(set) var favoriteIds: [Int] = []

    func loadFavorites(completion: @escaping () -> Void) {
        APIService.shared.fetchFavorites { ids in
            DispatchQueue.main.async {
                self.favoriteIds = ids
                completion()
            }
        }
    }

    func isFavorite(_ productId: Int) -> Bool {
        return favoriteIds.contains(productId)
    }

    func toggle(productId: Int, completion: @escaping () -> Void) {

        if isFavorite(productId) {

            APIService.shared.removeFavorite(productId: productId) {
                DispatchQueue.main.async {
                    self.favoriteIds.removeAll { $0 == productId }
                    completion()
                }
            }

        } else {

            APIService.shared.addFavorite(productId: productId) {
                DispatchQueue.main.async {
                    self.favoriteIds.append(productId)
                    completion()
                }
            }
        }
    }
    func removeAll(completion: @escaping () -> Void) {

        let group = DispatchGroup()

        for id in favoriteIds {
            group.enter()
            APIService.shared.removeFavorite(productId: id) {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.favoriteIds.removeAll()
            completion()
        }
    }
    
    
    

}

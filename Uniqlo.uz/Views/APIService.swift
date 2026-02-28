//
//  APIService.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 17/02/26.
//
import Foundation

final class APIService {

    static let shared = APIService()
    private let baseURL = "https://fake-store-backend-production.up.railway.app"
    private var token: String? {
        UserDefaults.standard.string(forKey: "access_token")
    }

    func addToCart(productId: Int, completion: @escaping () -> Void) {
        
        guard let token else { return }

        let url = URL(string: "\(baseURL)/api/cart/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "product_id": productId,
            "quantity": 1
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }
    
    func fetchCart(completion: @escaping ([(Int, Int)]) -> Void) {
        
        guard let token = token else { return }

        let url = URL(string: "\(baseURL)/api/cart/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            guard let data = data else { return }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {

                    var result: [(Int, Int)] = []

                    for item in jsonArray {
                        if let productId = item["product_id"] as? Int,
                           let quantity = item["quantity"] as? Int {
                            result.append((productId, quantity))
                        }
                    }
                    print("Backend cart raw:", String(data: data, encoding: .utf8) ?? "")
                    completion(result)
                }
                
            } catch {
                print("Fetch cart error")
            }

        }.resume()
    }
    
    func updateCart(productId: Int, quantity: Int, completion: @escaping () -> Void) {

        guard let token = token else { return }

        let url = URL(string: "\(baseURL)/api/cart/")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "product_id": productId,
            "quantity": quantity
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }
    
    
    func deleteFromCart(productId: Int, completion: @escaping () -> Void) {

        guard let token = token else { return }

        let url = URL(string: "\(baseURL)/api/cart/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "product_id": productId
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }
    
    
    func deleteAllCart(completion: @escaping () -> Void) {

        guard let token = token else { return }
        
        let url = URL(string: "\(baseURL)/api/cart/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }
    func login(username: String,
               password: String,
               completion: @escaping (Bool) -> Void) {

        let url = URL(string: "\(baseURL)/api/login/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "username": username,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let access = json["access"] as? String {

                UserDefaults.standard.set(access, forKey: "access_token")
                DispatchQueue.main.async {
                    completion(true)
                }

            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
            print("STATUS:", (response as? HTTPURLResponse)?.statusCode ?? 0)
            print("LOGIN RAW:", String(data: data, encoding: .utf8) ?? "")

        }.resume()
    }

    
    
    
    func signup(username: String,
                password: String,
                name: String,
                completion: @escaping (Bool) -> Void) {

        let url = URL(string: "\(baseURL)/api/signup/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "username": username,
            "password": password,
            "name": name
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data else {
                completion(false)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let access = json["access"] as? String {

                UserDefaults.standard.set(access, forKey: "access_token")
                DispatchQueue.main.async {
                    completion(true)
                }

            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
            print("STATUS:", (response as? HTTPURLResponse)?.statusCode ?? 0)
            print("SIGNUP RAW:", String(data: data, encoding: .utf8) ?? "")

        }.resume()
    }
    
    // MARK: - Favorites

    func fetchFavorites(completion: @escaping ([Int]) -> Void) {

        guard let token = token else { return }

        let url = URL(string: "\(baseURL)/api/favorites/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in

            guard let data = data else { return }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {

                let ids = json.compactMap { $0["product_id"] as? Int }
                completion(ids)
            }

        }.resume()
    }


    func addFavorite(productId: Int, completion: @escaping () -> Void) {

        guard let token = token else { return }

        let url = URL(string: "\(baseURL)/api/favorites/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "product_id": productId
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }


    func removeFavorite(productId: Int, completion: @escaping () -> Void) {

        guard let token = token else { return }

        let url = URL(string: "\(baseURL)/api/favorites/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "product_id": productId
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }



}

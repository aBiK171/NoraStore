//
//  APIRouter.swift
//  CatAPITutorial
//
//  Created by Abboskhon Rakhimov on 21/01/26.
//

import Foundation

enum APIRouter {
//    case getUser(id: Int)
//    case createUser(name: String, email: String)
//    case updateUser(id: Int, name: String, email: String)
//    case deleteUser(id: Int)
//    case searchUsers(query: String, page: Int)
    
    case getProducts(limit: Int, skip: Int)
    case getCategories
    case getProductsByCategory(category: String)
    case searchProducts(query: String)

}

extension APIRouter: Endpoint {
    
    var baseURL: URL {
        return URL(string: "https://dummyjson.com")!
    }

    var path: String {
        switch self {
        case .getProducts:
            return "/products"
        case .getCategories:
            return "/products/category-list"
        case .getProductsByCategory(let category):
            return "/products/category/\(category)"
        case .searchProducts(query: let query):
            return "/products/search"
        }
    }


    
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        
        
        headers.add(.json, forKey: .accept)
        return headers
    }
    
    
    var method: HTTPMethod {
        switch self {
//        case .getUser, .searchUsers:
//            return .get
//        case .createUser:
//            return .post
//        case .updateUser:
//            return .put
//        case .deleteUser:
//            return .delete
        case .getCategories, .getProducts, .getProductsByCategory, .searchProducts:
            return .get
            
        }
    }
   
    var queryParameters: [String: Any]? {
        switch self {
        case .getProducts(let limit, let skip):
            return [
                "limit": limit,
                "skip": skip
            ]
        case .searchProducts(let query):
            return ["q": query]
        default:
            return nil
        }
    }

}

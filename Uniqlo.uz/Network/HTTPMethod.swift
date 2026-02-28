//
//  HTTPMethod.swift
//  networking_tutorial
//
//  Created by Abboskhon Rakhimov on 16/01/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum HTTPHeaderKey: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case accept = "Accept"
    case userAgent = "User-Agent"
}

enum HTTPHeaderValue: String {
    case json = "application/json"
    case formUrlEncoded = "application/x-www-form-urlencoded"
    case multipartFormData = "multipart/form-data"
}

struct HTTPHeaders {
    private var headers: [String: String] = [:]
    
    mutating func add(_ value: String, forKey key: String) {
        headers[key] = value
    }
    
    mutating func add(_ value: HTTPHeaderValue, forKey key: HTTPHeaderKey) {
        headers[key.rawValue] = value.rawValue
    }
    
    func toDictionary() -> [String: String] {
        return headers
    }
    
}

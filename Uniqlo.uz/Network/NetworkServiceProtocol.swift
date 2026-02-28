//
//  NetworkServiceProtocol.swift
//  networking_tutorial
//
//  Created by Abboskhon Rakhimov on 16/01/26.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws
}

final class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
    private let decoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T{
        let request = try endpoint.asURLRequest()
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try validateStatusCode(httpResponse.statusCode)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func  request(_ endpoint: any Endpoint) async throws {
        let request = try endpoint.asURLRequest()
        
        let (_, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try validateStatusCode(httpResponse.statusCode) 
    }
}

private func validateStatusCode(_ statusCode: Int) throws {
    switch statusCode {
    case 200...299:
        return
    case 401:
        throw NetworkError.unauthorized
    case 400...499:
        throw NetworkError.httpError(statusCode: statusCode, message: nil)
    case 500...599:
        throw NetworkError.serverError("Server error")
    default:
        throw NetworkError.invalidResponse
    }
}

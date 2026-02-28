
import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var queryParameters: [String: Any]? { get }
    var bodyParameters: [String: Any]? { get }
    var timeoutInterval: TimeInterval { get }
}

extension Endpoint {
    var timeoutInterval: TimeInterval {
        return 60.0
    }
    
  

    
    var queryParameters : [String: Any]? {
        return nil
    }
    
    var bodyParameters: [String: Any]? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        
        //MARK: - QUERRY
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            urlComponents.queryItems = queryParameters.map { key, value in
                    URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let finalURL = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        
        //MARK: - HEADER
        headers.toDictionary().forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        //MARK: - BODY
        if let bodyParameters = bodyParameters, !bodyParameters.isEmpty {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
            } catch {
                throw NetworkError.encodingError(error)
            }
        }
        return request
    }
}

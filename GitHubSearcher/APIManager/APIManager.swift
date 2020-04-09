//
//  APIManager.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/6/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

typealias APIManagerCompletionHandler<T: Decodable> = (T?, URLResponse?, Error?) -> Void

class APIManager {
    
    public static let shared: APIManager = APIManager()
    
    private init() { }
    
    public func request<T: Decodable>(type: ServiceType, completionHandler: @escaping APIManagerCompletionHandler<T>) {
        let apiService = APIService(type: type)
        guard let url = URL(string: BaseURL.url + apiService.url) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = apiService.httpMethod
        request.allHTTPHeaderFields = apiService.headers
        print("API call is being made...")
        URLSession.shared.dataTask(with: request, completionHandler: { data, urlResponse, error in
            guard let unwrappedData = data else {
                return
            }
            if let httpResponse = urlResponse as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    let result = try! JSONDecoder().decode(T.self, from: unwrappedData)
                    completionHandler(result, urlResponse, error)
                case 401:
                    print("Unauthorized!!. Status Code \(httpResponse.statusCode).")
                default:
                    print("Bummer!!. Status Code \(httpResponse.statusCode). This API probably has a rate-limit.")
                }
            }
        }).resume()
    }
}

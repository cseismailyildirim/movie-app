//
//  NetworkManager.swift
//  movie-app
//
//  Created by ismailyildirim on 6.03.2021.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(model: NetworkConstants, onSuccess: @escaping((T) -> Void), onError: @escaping((String) -> Void))
}

class NetworkManager: NetworkManagerProtocol {
    
    func request<T: Decodable>(model: NetworkConstants, onSuccess: @escaping((T) -> Void), onError: @escaping((String) -> Void)) {
        
        let session = URLSession.shared
        var urlRequest: URLRequest = URLRequest(url: URL(string: model.BASE_URL + model.endpoint)!)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
          
            guard response != nil else {
                onError("Response is nil")
                return
            }
            
            
            if let error = error {
                onError("Error: \(error.localizedDescription)")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let json: T = try decoder.decode(T.self, from: data!)
                onSuccess(json)
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
        })
        
        task.resume()
    }
    
}

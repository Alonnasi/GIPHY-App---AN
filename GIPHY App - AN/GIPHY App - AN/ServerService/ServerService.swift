//
//  ServerService.swift
//  GIPHY App - AN
//
//  Created by Alon Nasi on 18  2022.
//

import Foundation

class ServerService {
    
    private let baseURL = "https://api.giphy.com/v1/gifs"
    private let apiKey = "?api_key=Zz7XnA0RZzJJetQAQv1e2c7ErivA9F5u"
    
    func performRequest(offset: Int, query: String?, completion: @escaping (SereverModel?, Error?) -> ()){
        
        var apiString = ""
        
        if query == nil || query == "" {
            apiString = "\(baseURL)/trending\(apiKey)&offset=\(String(offset))&limit=40"
        } else {
            
            guard let query = query else {
                return
            }
            let trimmedString = query.trimmingCharacters(in: .whitespaces)
            let stringForUrl = trimmedString.replacingOccurrences(of: " ", with: "+")
            apiString = "\(baseURL)/search\(apiKey)&q=\(stringForUrl)&offset=\(String(offset))&limit=40"
        }

        guard let url = URL(string: apiString) else {
            let error = NSError(domain: "URL not Responding", code: 0, userInfo: nil)
            completion(nil, error)
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            
            guard self != nil else {
                return
            }
            
            guard error == nil else {
                let error = NSError(domain: "URL not Responding", code: 0, userInfo: nil)
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(SereverModel.self, from: data)
                completion(decodedData, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
        
}

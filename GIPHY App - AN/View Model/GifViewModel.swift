//
//  GifViewModel.swift
//  GIPHY App - AN
//
//  Created by Alon Nasi on 18  2022.
//

import Foundation

class GifViewModel {
    
    private let serverService = ServerService()
    private let baseURL = "https://api.giphy.com/v1/gifs"
    private let apiKey = "?api_key=Zz7XnA0RZzJJetQAQv1e2c7ErivA9F5u"
        
    func getGifsFromSearch(offset: Int, query: String? ,completion: @escaping (SereverModel?) -> Void) {
        
        if let queryString = query {
            let trimmedString = queryString.trimmingCharacters(in: .whitespaces)
            let stringForUrl = trimmedString.replacingOccurrences(of: " ", with: "+")
            let urlString = "\(baseURL)/search\(apiKey)&q=\(stringForUrl)&offset=\(String(offset))&limit=40"
            serverService.newPerformRequest(urlString: urlString) { model, error in

                guard error == nil else {
                    return
                }
                guard model != nil else {
                    return
                }
                
                completion(model)
            }
        }
        
    }
    
    func getGifsFromTrending(offset: Int, completion: @escaping (SereverModel?) -> Void) {
        
        let urlString = "\(baseURL)/trending\(apiKey)&offset=\(String(offset))&limit=40"
        serverService.newPerformRequest(urlString: urlString) { model, error in

            guard error == nil else {
                return
            }
    
            guard model != nil else {
                return
            }
            
            completion(model)
        }
    }
    
    
}

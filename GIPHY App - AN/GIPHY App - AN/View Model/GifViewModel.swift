//
//  GifViewModel.swift
//  GIPHY App - AN
//
//  Created by Alon Nasi on 18  2022.
//

import Foundation

class GifViewModel {
    
    private let serverService = ServerService()
    
    func getGifs(offset: Int, query: String? ,completion: @escaping (SereverModel?) -> Void) {
        
        serverService.performRequest(offset: offset, query: query) { model, error in
            
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

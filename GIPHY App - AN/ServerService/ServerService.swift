//
//  ServerService.swift
//  GIPHY App - AN
//
//  Created by Alon Nasi on 18  2022.
//

import Foundation

class ServerService {
        
    func newPerformRequest(urlString: String, completion: @escaping (SereverModel?, Error?) -> ()) {
        
        guard let url = URL(string: urlString) else {
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

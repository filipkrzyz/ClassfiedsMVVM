//
//  APIRequest.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import Foundation

enum DataError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct APIRequest {
    
    private let apiKey = "14533548-456de78912cc6ad988b1c35af"
    let resourceURL: URL
    
    init(query: String, perPage: String) {
        
        let resourceString = "https://pixabay.com/api/?key=\(apiKey)&image_type=photo&pretty=true&q=\(query)&per_page=\(perPage)"
        
        let urlResourceString = resourceString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let resourceURL = URL(string: urlResourceString) else { fatalError() }
        
        self.resourceURL = resourceURL
        print("APIRequest for: \(query)")
        print(urlResourceString)
    }
    
    
    
    /// Starts the URLSession to get images data with resourceURL and decodes them to the Hit model.
    func getImages(completionHandler: @escaping(Result<[ImageData], DataError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, _, _) in
            
            guard let jsonData = data else {
                completionHandler(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(Response.self, from: jsonData)
                completionHandler(.success(response.hits))
                
            } catch {
                completionHandler(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}

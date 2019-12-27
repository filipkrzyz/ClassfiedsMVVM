//
//  CustomImageViewModel.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import Foundation

struct CustomImageViewModel {
    
    var imageData: Box<NSData?> = Box(nil)
    
    let imageCache = NSCache<NSString, NSData>()
    
    func downloadImageUsingURLString(urlString: String) {
        let url = URL(string: urlString)
        let imageUrlString = urlString
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            imageData.value = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print (error!)
            }
            DispatchQueue.main.async {
                
                guard let imageDataToCache = data as NSData? else { return }
                
                if imageUrlString == urlString {
                    self.imageData.value = imageDataToCache
                }
                self.imageCache.setObject(imageDataToCache, forKey: urlString as NSString)
            }
        }.resume()
    }
}

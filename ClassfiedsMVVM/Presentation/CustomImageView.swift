//
//  CustomImageView.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit


/// Custom ImageView which provides a method for loading an image from a provided URL and displays activity indicator while the image is being loaded
class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    let imageCache = NSCache<NSString, UIImage>()
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString)
        
        imageUrlString = urlString
        
        image = UIImage(named: "noimg")
    
        spinner.color = .lightGray
        addSpinner(spinner: spinner)
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            image = imageFromCache
            removeSpinner(spinner: spinner)
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print (error!)
            }
            
            DispatchQueue.main.async {
                
                guard let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                    self.removeSpinner(spinner: self.spinner)
                }
                
                self.imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
        }.resume()
    }
}

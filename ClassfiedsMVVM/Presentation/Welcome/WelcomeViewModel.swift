//
//  WelcomeViewModel.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import Foundation

struct WelcomeViewModel {
    
    var imageStringURL: Box<String?> = Box(nil)
    
    /// Checks for a favouriteCategory in UserDefaults and requests the image data for this category from the pixbay rest API and then loads this image using URL string to the imageView
    func fetchFavCategory() {
        guard let favCategoryName = UserDefaults.standard.string(forKey: "favouriteCategory") else {
            print("No favourite category found")
            return
        }
        print("Fav Category: \(favCategoryName)")
        
        let apiRequest = APIRequest(query: favCategoryName, perPage: "3")
        
        apiRequest.getImages() { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let imagesData):
                DispatchQueue.main.async {
                    self.imageStringURL.value = imagesData[0].webformatURL
                }
            }
        }
    }
}

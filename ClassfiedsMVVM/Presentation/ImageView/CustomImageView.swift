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
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    let customImageViewModel = CustomImageViewModel()
    
    func loadImageUsingUrlString(urlString: String) {
        
        image = UIImage(named: "noimg")
        
        customImageViewModel.downloadImageUsingURLString(urlString: urlString)
        
        spinner.color = .lightGray
        addSpinner(spinner: spinner)
        
        customImageViewModel.imageData.bind { [unowned self] in
            if $0 != nil {
                self.image = UIImage(data: $0! as Data)
                self.removeSpinner(spinner: self.spinner)
            }
        }
    }
}

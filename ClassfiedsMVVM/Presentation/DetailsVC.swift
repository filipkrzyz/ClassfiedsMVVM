//
//  DetailsVC.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
       
    let favCategoryImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "noimg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var imageData: ImageData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(topLabel)
        view.addSubview(favCategoryImageView)
        view.addSubview(descriptionLabel)
        
        view.addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: topLabel)
        
        view.addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: favCategoryImageView)
        
        view.addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: descriptionLabel)
        
        view.addConstraintWithFormat(format: "V:|-110-[v0(60)]-30-[v1(250)]-20-[v2]", views: topLabel, favCategoryImageView, descriptionLabel)
        
        topLabel.attributedText = NSAttributedString(string: "Photo by \(imageData!.user)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23, weight: .semibold)])
        favCategoryImageView.loadImageUsingUrlString(urlString: imageData!.webformatURL)
        descriptionLabel.text = "Tags: \(imageData!.tags)"
    }

}

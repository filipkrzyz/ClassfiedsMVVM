//
//  CustomCell.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

/// Custom Cell with just an ImageView inside
class CustomCell: UICollectionViewCell {
    
    var imageData: ImageData? {
        didSet {
            setupThumbnailImage()
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "noimg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupThumbnailImage() {
        if let imageUrl = imageData?.webformatURL {
            self.thumbnailImageView.loadImageUsingUrlString(urlString: imageUrl)
        }
    }
    
    func setupViews() {
        addSubview(thumbnailImageView)
        addConstraintWithFormat(format: "H:|[v0]|", views: thumbnailImageView)
        addConstraintWithFormat(format: "V:|[v0]|", views: thumbnailImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
}

/// Subclass of CustomCell which adds a label underneth the ImageView
class CustomLabeledCell: CustomCell {
    
    var categoryName: String? {
        didSet {
            imageLabel.text = categoryName
        }
    }
    
    let imageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        return label
    }()
    
    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(imageLabel)
        addConstraintWithFormat(format: "H:|[v0]|", views: thumbnailImageView)
        addConstraintWithFormat(format: "H:|-8-[v0]-8-|", views: imageLabel)
        addConstraintWithFormat(format: "V:|[v0][v1(44)]|", views: thumbnailImageView, imageLabel)
    }
    
}


//
//  WelcomeVC.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Welcome to the classifieds site!", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23, weight: .semibold)])
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
    
    let showCategoriesButton:  UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .systemBlue
        b.setTitle("List of categories", for: .normal)
        b.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        view.addSubview(favCategoryImageView)
        view.addSubview(showCategoriesButton)
        
        view.addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: welcomeLabel)
        
        view.addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: favCategoryImageView)
        
        view.addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: showCategoriesButton)
        
        view.addConstraintWithFormat(format: "V:|-110-[v0(60)]-60-[v1(250)]-50-[v2(50)]", views: welcomeLabel, favCategoryImageView, showCategoriesButton)
        
        fetchFavCategory()
    }
    
    /// Checks for a favouriteCategory in UserDefaults and requests the image data for this category from the pixbay rest API and then loads this image using URL string to the imageView
    func fetchFavCategory() {
        guard let favCategoryName = UserDefaults.standard.string(forKey: "favouriteCategory") else { print("No favourite category found")
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
                    self.favCategoryImageView.loadImageUsingUrlString(urlString: imagesData[0].webformatURL)
                }
            }
        }
    }
    
    /// Pushes the CategoriesVC (which shows the list of categories) onto navigationController
    /// - Parameter sender: the button after pressing which the method is called
    @objc func showCategories(sender: UIButton!) {
        let layout = UICollectionViewFlowLayout()
        let categoriesVC = CategoriesVC(collectionViewLayout: layout)
        navigationController?.pushViewController(categoriesVC, animated: true)
    }
    
}

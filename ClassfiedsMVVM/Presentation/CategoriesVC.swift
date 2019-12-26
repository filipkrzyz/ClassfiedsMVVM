//
//  CategoriesVC.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

class CategoriesVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    /// Array of sorted categories based on number of clicks in descending order
    var categories = [Category]()
    
    private let cellId = "CollectionCell"
    
    let sqliteManager = SQLiteManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sortCategories()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .lightGray
        
        navigationItem.title = "Categories"
        
        // register cell
        collectionView!.register(CustomLabeledCell.self, forCellWithReuseIdentifier: cellId)
        
        categories = sqliteManager.selectData()
        sortCategories()
        collectionView.reloadData()
        fetchCategoriesImages()
    }
    
    /// For each category in the array, API request is created to download images data for each category. ImagesData is saved in the categories array and the collectionView reloaded
    func fetchCategoriesImages() {
        for (index, category) in categories.enumerated() {
            let apiRequest = APIRequest(query: category.categoryName, perPage: "12")
            
            apiRequest.getImages() { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imagesData):
                    self.categories[index].images = imagesData
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomLabeledCell
        
        cell.backgroundColor = .black
        
        cell.categoryName = self.categories[indexPath.row].categoryName
        
        cell.imageData = self.categories[indexPath.row].images?[0]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize
        
        let frameWidth = self.collectionView.frame.size.width
        let cellHeight = self.collectionView.frame.height/5
        let inset: CGFloat = 16
        
        if UserDefaults.standard.bool(forKey: "launchedBefore") {
            if indexPath.row == 0 {
                size = CGSize(width: (frameWidth - (2*inset)), height: cellHeight)
            } else if indexPath.row == 1 {
                size = CGSize(width: ((frameWidth - (3*inset))/3)*2, height: cellHeight)
            } else {
                size = CGSize(width: (frameWidth - (4*inset))/3, height: cellHeight)
            }
        } else {
            size = CGSize(width: (frameWidth - (4*inset))/3, height: cellHeight)
        }
        
        
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.9
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        
        categories[indexPath.row].clicks += 1
        
        sqliteManager.updateClicks(id: categories[indexPath.row].categoryId, clicks: categories[indexPath.row].clicks)
        
        let layout = UICollectionViewFlowLayout()
        let imagesVC = ImagesVC(collectionViewLayout: layout)
        
        imagesVC.images = categories[indexPath.row].images
        
        navigationController?.pushViewController(imagesVC, animated: true)
        imagesVC.navigationItem.title = categories[indexPath.row].categoryName
        sortCategories()
    }
    
    
    /// Sorts categories within the array in descending order. Saves the first item in UserDefaults as a favouriteCategory. Reloads the collectionView
    func sortCategories() {
        categories.sort { $0.clicks > $1.clicks }
        UserDefaults.standard.set(categories[0].categoryName, forKey: "favouriteCategory")
//        collectionView.reloadData()
    }
}

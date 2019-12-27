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
    
    let categoriesViewModel = CategoriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .lightGray
        
        navigationItem.title = "Categories"
        
        // register cell
        collectionView!.register(CustomLabeledCell.self, forCellWithReuseIdentifier: cellId)
        
        
        categoriesViewModel.fetchCategoriesImages()
        categoriesViewModel.categories.bind { [unowned self] in
            self.categories = $0
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
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
        
        let (width, height): (Double, Double)
        
        let frameWidth = Double(self.collectionView.frame.size.width)
        let frameHeight = Double(self.collectionView.frame.height)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        (width, height) = categoriesViewModel.cellSize(frameWidth: frameWidth, frameHeight: frameHeight, row: indexPath.row, launchedBefore: launchedBefore)
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.9
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        
        categoriesViewModel.updateClicks(id: categories[indexPath.row].categoryId, row: indexPath.row)
        
        let layout = UICollectionViewFlowLayout()
        let imagesVC = ImagesVC(collectionViewLayout: layout)
        
        imagesVC.images = categories[indexPath.row].images
        
        navigationController?.pushViewController(imagesVC, animated: true)
        imagesVC.navigationItem.title = categories[indexPath.row].categoryName
        categoriesViewModel.sortCategories()
    }
}

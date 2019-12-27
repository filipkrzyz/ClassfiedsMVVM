//
//  ImagesVC.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

private let cellId = "CollectionCell"

class ImagesVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    /// An array of image items data
    var images: [ImageData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .lightGray
        
        // Register cell class
        self.collectionView!.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        
        cell.imageData = images?[indexPath.row]
        
        cell.backgroundColor = .black
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.collectionView.frame.size.width - (4*16))/3, height: self.collectionView.frame.height/8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailsVC = DetailsVC()
        detailsVC.imageData = images?[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

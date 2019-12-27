//
//  CategoriesViewModel.swift
//  ClassfiedsMVVM
//
//  Created by Filip Krzyzanowski on 26/12/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import Foundation

struct CategoriesViewModel {
    
    /// Array of sorted categories based on number of clicks in descending order
    var categories: Box<[Category]> = Box([])
    
    let sqliteManager = SQLiteManager()
    
    /// For each category in the array, API request is created to download images data for each category. ImagesData is saved in the categories array and the collectionView reloaded
    func fetchCategoriesImages() {
        categories.value = sqliteManager.selectData()
        sortCategories()
        for (index, category) in categories.value.enumerated() {
            let apiRequest = APIRequest(query: category.categoryName, perPage: "12")
            
            apiRequest.getImages() { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imagesData):
                    self.categories.value[index].images = imagesData
                }
            }
        }
    }
    
    func updateClicks(id: Int, row: Int ) {
        categories.value[row].clicks += 1
        
        sqliteManager.updateClicks(id: id, clicks: categories.value[row].clicks)
    }
    
    /// Sorts categories within the array in descending order. Saves the first item in UserDefaults as a favouriteCategory.
    func sortCategories() {
        categories.value.sort { $0.clicks > $1.clicks }
        UserDefaults.standard.set(categories.value[0].categoryName, forKey: "favouriteCategory")
        
    }
    
    func cellSize(frameWidth: Double, frameHeight: Double, row: Int, launchedBefore: Bool) -> (Double, Double) {
        
        let cellHeight = frameHeight/5
        let inset: Double = 16
        
        let (width, height): (Double, Double)
        
        if launchedBefore {
            if row == 0 {
                (width, height) = ((frameWidth - (2*inset)), cellHeight)
            } else if row == 1 {
                (width, height) = (((frameWidth - (3*inset))/3)*2, cellHeight)
            } else {
                (width, height) = ((frameWidth - (4*inset))/3, cellHeight)
            }
        } else {
            (width, height) = ((frameWidth - (4*inset))/3, cellHeight)
        }
        return (width, height)
    }
}

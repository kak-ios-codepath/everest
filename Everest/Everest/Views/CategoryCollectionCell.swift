//
//  CategoryCollectionCell.swift
//  Everest
//
//  Created by user on 10/18/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import AFNetworking

class CategoryCollectionCell: UICollectionViewCell {
 
  @IBOutlet weak var categoryImageView: UIImageView!
  @IBOutlet weak var categoryTitleLable: UILabel!
  
  var categoryPhotoURL:String! {
    didSet {
      if let url = URL(string: categoryPhotoURL) {
        categoryImageView.setImageWith(url)
      }
    }
  }

  var categoryTitle:String! {
    didSet {
      self.categoryTitleLable.text = categoryTitle
    }
  }
  
}

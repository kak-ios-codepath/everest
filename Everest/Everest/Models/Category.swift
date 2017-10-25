//
//  Category.swift
//  Everest
//
//  Created by user on 10/21/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking

class Category {
    var title: String!
    var acts: [Act]!
    var imageUrl: String!
    
    init(categoryTitle: String, category: NSDictionary) {
        self.title = categoryTitle
        self.acts = category.flatMap { Act(id: $0 as! String, category: categoryTitle, title: $1 as! String, score: ACT_DEFAULT_SCORE) }
        FireBaseManager.shared.fetchCategoryImageUrl(title: title) { (url, error) in
            if error == nil {
                self.imageUrl = url
            }
        }
    }
}

//
//  Act.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import SwiftyJSON


let ACT_DEFAULT_SCORE = 4;

class Act: NSObject, NSCoding {
    
    var id: String
    var category: String
    var title: String
    var score: Int
    
    init(id: String, category: String, title: String, score: Int) {
        self.id = id
        self.category = category
        self.title = title
        self.score = score
    }
    
    init(act: JSON) {
        self.id = act["id"].string!
        self.category = act["category"].string!
        self.title = act["title"].string!
        self.score = act["score"].int!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.category, forKey: "category")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.score, forKey: "score")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let id = decoder.decodeObject(forKey: "id") as! String
        let category = decoder.decodeObject(forKey: "category") as! String
        let title = decoder.decodeObject(forKey: "title") as! String
        let score = decoder.decodeInt32(forKey: "score")
        
        self.init(id: id, category: category, title: title, score: Int(score))
    }
}



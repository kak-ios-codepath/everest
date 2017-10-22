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

class Act: NSObject {

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
  
  // This code will allow the user to create new acts
  //  init(id: String, title: String) {
  //    self.id = id
  //    self.title = title
  //  }
}



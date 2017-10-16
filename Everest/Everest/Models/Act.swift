//
//  Act.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class Act: NSObject {

  var id: String
  var category: String
  var name: String
  var details: String
  
  init(act: JSON) {
    self.id = act["id"].string!
    self.category = act["category"].string!
    self.name = act["name"].string!
    self.details = act["details"].string!
  }
  
  // This code will allow the user to create new acts
  //  init(id: String, category: String, name: String, details: String) {
  //    self.id = id
  //    self.category = category
  //    self.name = name
  //    self.details = details
  //  }
}

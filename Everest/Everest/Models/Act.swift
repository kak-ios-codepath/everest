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
  var title: String
  
  init(id: String, title: String) {
    self.id = id
    self.title = title
  }
  
  // This code will allow the user to create new acts
  //  init(id: String, title: String) {
  //    self.id = id
  //    self.title = title
  //  }
}

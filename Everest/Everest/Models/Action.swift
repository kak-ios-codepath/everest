//
//  Action.swift
//  Everest
//
//  Created by user on 10/14/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class Action: NSObject {
  
  var id: String          //same id from acts
  var createdAt: String
  var status: String
  var momentId: String?
  var likes: Int
  
  init(id: String, createdAt: String, status: String, likes: Int = 0) {
    self.id = id
    self.createdAt = createdAt
    self.status = status
    self.likes = likes
  }
  
  init(action: JSON) {
    self.id = action["id"].string!
    self.createdAt = action["createdAt"].string!
    self.status = action["status"].string!
    self.momentId = action["momentId"].string
    self.likes = action["likes"].int!
  }
}

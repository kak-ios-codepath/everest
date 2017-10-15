//
//  User.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject {
  
  var id: String
  var name: String
  var email: String
  var phone: String?
  var anonymous: Bool
  var createdDate: String
  var actions: [Action]? //it will contain an array of acts' ids and any needed info
  var momentIds: [String]?
  var ideas: [Act]?
  var score: Int
  
  init(id: String, name: String, email: String, phone: String?, anonymous: Bool, createdDate: String, score: Int = 0) {
    self.id = id
    self.name = id
    self.email = email
    self.phone = phone
    self.anonymous = anonymous
    self.createdDate = createdDate
    self.score = score
  }
  
  init(user: JSON) {
    self.id = user["id"].string!
    self.name = user["name"].string!
    self.email = user["email"].string!
    self.phone = user["phone"].string
    self.anonymous = user["anonymous"].bool!
    self.createdDate = user["createdDate"].string!
    if let actions = user["actions"].array {
      self.actions = actions.map { Action(action: $0) }
    }
    if let momentIds = user["momentIds"].dictionary {
      self.momentIds = momentIds.map { $1.string! }
    }
    if let ideas = user["ideas"].array {
      self.ideas = ideas.map { Act(act: $0) }
    }
    self.score = user["score"].int!
  }
}


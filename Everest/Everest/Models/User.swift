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
  var profileUrl: String?
  var isAnonymous: Bool
  var createdDate: String
  var actions: [Action]? //it will contain an array of acts' ids and any needed info
  var momentIds: [String]?
  var suggestedActs: [Act]?
  var score: Int
  
    init(id: String, name: String, email: String, phone: String?, profileUrl: String?, isAnonymous: Bool, createdDate: String, score: Int = 0) {
    self.id = id
    self.name = id
    self.email = email
    self.phone = phone
    self.profileUrl = profileUrl
    self.isAnonymous = isAnonymous
    self.createdDate = createdDate
    self.score = score
  }
  
  init(user: JSON) {
    self.id = user["id"].string!
    self.name = user["name"].string!
    self.email = user["email"].string!
    self.phone = user["phone"].string
    self.profileUrl = user["profileUrl"].string
    self.isAnonymous = user["isAnonymous"].bool!
    self.createdDate = user["createdDate"].string!
    if let actions = user["actions"].array {
      self.actions = actions.map { Action(action: $0) }
    }
    if let momentIds = user["momentIds"].dictionary {
      self.momentIds = momentIds.map { $1.string! }
    }
//    if let suggestedActs = user["suggestedActs"].array {
//      suggestedActs = ideas.map { Act(id: String, title: <#String#>) }
//    }
    self.score = user["score"].int!
  }
}


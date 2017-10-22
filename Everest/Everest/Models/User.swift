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
  var providerId: String = "password"
  var name: String
  var email: String
  var phone: String?
  var profilePhotoUrl: String?
  var isAnonymous: Bool
  var createdDate: String
  var actions: [Action]? //it will contain an array of acts' ids
  var momentIds: [String]?
  var suggestedActs: [String]?
  var score: Int
    
  static var currentUser: User?
    
    init(id: String, providerId: String, name: String, email: String, phone: String?, profilePhotoUrl: String?, isAnonymous: Bool, createdDate: String, actions: [Action]?, momentIds: [String]?, score: Int = 0) {
    self.id = id
    self.providerId = providerId
    self.name = name
    self.email = email
    self.phone = phone
    self.profilePhotoUrl = profilePhotoUrl
    self.isAnonymous = isAnonymous
    self.createdDate = createdDate
    self.momentIds = momentIds
    self.actions = actions
    self.score = score
  }
  
  init(user: JSON) {
    self.id = user["id"].string!
    self.name = user["name"].string!
    self.email = user["email"].string!
    self.phone = user["phone"].string
    self.profilePhotoUrl = user["profilePhotoUrl"].string
    self.isAnonymous = user["isAnonymous"].bool!
    self.createdDate = user["createdDate"].string!
    if let providerId = user["providerId"].string {
        self.providerId = providerId
    }
    if let actions = user["actions"].dictionary {
      self.actions = actions.map { Action(action: $0.value) }
    }
    if let momentIds = user["momentIds"].dictionary {
      self.momentIds = Array(momentIds.keys)
    }
//    if let suggestedActs = user["suggestedActs"].array {
//      suggestedActs = ideas.map { Act(id: String, title: <#String#>) }
//    }
    self.score = user["score"].int!
  }
}


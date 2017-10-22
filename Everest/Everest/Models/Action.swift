//
//  Action.swift
//  Everest
//
//  Created by user on 10/14/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ActionStatus: String {
    case created = "created"
    case inProgress = "inprogress"
    case completed = "completed"
    case deleted = "deleted"
    case expired = "expired"
}

class Action: NSObject {
  
  var id: String          //same id from acts
  var createdAt: String
  var status: String
  var actTitle : String
  
    init(id: String, actTitle: String, createdAt: String, status: String) {
    self.id = id
    self.createdAt = createdAt
    self.status = status
    self.actTitle = actTitle
  }
  
  init(action: JSON) {
    self.id = action["id"].string!
    self.createdAt = action["createdAt"].string!
    self.status = action["status"].string!
    self.actTitle = action["actTitle"].string!

//    if let actDictionary = action["act"].dictionary {
//    }


  }
}

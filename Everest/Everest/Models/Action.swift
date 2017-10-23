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
    var momentIds: [String]?
    
    init(id: String, createdAt: String, status: String) {
        self.id = id
        self.createdAt = createdAt
        self.status = status
    }
    
    init(action: JSON) {
        self.id = action["id"].string!
        self.createdAt = action["createdAt"].string!
        self.status = action["status"].string!
        if let momentIds = action["momentIds"].dictionary {
            self.momentIds = Array(momentIds.keys)
        }
    }
}

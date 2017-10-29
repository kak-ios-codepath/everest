//
//  Constants.swift
//  Everest
//
//  Created by user on 10/23/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import Foundation

class Constants {
    
    static let FINISHING_MOMENT_REWARD = 10
    static let LENGTH_OF_FETCHED_LIST: UInt = 50
    
    enum ListType {
        case listTypeAccount
        case listTypeMoment
    }
    
    enum ActionStatus: String {
        case created = "created"
        case inProgress = "inprogress"
        case completed = "completed"
        case deleted = "deleted"
        case expired = "expired"
    }

}

//
//  Moment.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import SwiftyJSON

class Moment: NSObject {
    
    var id: String
    var title: String
    var details: String
    var actId: String
    var userId: String
    var profilePhotoUrl: String
    var userName: String
    var picUrls: [String]?
    var geoLocation: [String: String]?
    var location: String?
    var timestamp: String
    var likes: Int
    
    init(title: String, details: String, actId: String, userId: String, profilePhotoUrl: String, userName: String, timestamp: String, picUrls: [String]?, geoLocation: [String: String]?, location: String?, likes: Int = 0) {
        self.id = "" //It will be overwritten by unique id from firebase
        self.title = title
        self.details = details
        self.actId = actId
        self.userId = userId
        self.profilePhotoUrl = profilePhotoUrl
        self.userName = userName
        self.timestamp = timestamp
        self.picUrls = picUrls
        self.geoLocation = geoLocation
        self.location = location
        self.likes = likes
    }
    
    init(moment: JSON) {
        self.id = moment["id"].string!
        self.title = moment["title"].string!
        self.details = moment["details"].string!
        self.actId = moment["actId"].string!
        self.userId = moment["userId"].string!
        self.profilePhotoUrl = moment["profilePhotoUrl"].string!
        self.userName = moment["userName"].string!
        if let picUrls = moment["picUrls"].dictionary { //converting dict to array, neglecting the keys
            self.picUrls = picUrls.map { $1.string! }
        }
        if let geoLocation =  moment["geoLocation"].dictionary {
            self.geoLocation = ["lat": (geoLocation["lat"]?.string)!,
                                "lon": (geoLocation["lon"]?.string)!]
        }
        self.location = moment["location"].string
        self.timestamp = moment["timestamp"].string!
        self.likes = moment["likes"].int!
    }
}

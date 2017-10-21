//
//  MainManager.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/21/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import Foundation
import UIKit

class MainManager {
    
    static let shared = MainManager()
    
    func createNewAction(id: String, completion: @escaping (NSError?) -> ()) {
        let action = Action(id: id, createdAt: "\(Date())", status: ActionStatus.created.rawValue)
        FireBaseManager.shared.updateAction(action: action)
        FireBaseManager.shared.getUser(userID: (User.currentUser?.id)!) { (user, error) in
            User.currentUser = user
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ActionCreated"), object: nil)
            if error == nil {
                completion(nil)
            } else {
                completion(error! as NSError)
            }
            
        }
    }
}


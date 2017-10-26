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
    var availableCategories:[Category] = [Category]()
    var availableActs:[String : Act] = [String : Act] ()
    
    func initialize() {
        FireBaseManager.shared.fetchAvailableCategories { (categories, error) in
            if error == nil && categories != nil {
                self.availableCategories = categories!
                var availableActs:[String : Act]! = [String : Act] ()
                for category in categories! {
                    if category.acts != nil {
                        let dict =  category.acts.toDictionary { $0.id }
                        availableActs.append(with: dict)
                    }
                }
                self.availableActs = availableActs
            }
        }
        
        //Login setup
        LoginManager.shared.initialize()

    }
    
    
    func createNewAction(id: String, completion: @escaping (NSError?) -> ()) {
        let action = Action(id: id, createdAt: "\(Date())", status: Constants.ActionStatus.created.rawValue)
        FireBaseManager.shared.updateAction(action: action)
        FireBaseManager.shared.getUser(userID: (User.currentUser?.id)!) { (user, error) in
            if user != nil {
                User.currentUser = user
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ActionCreated"), object: nil)
                completion(nil)
            } else {
                completion(error! as NSError)
            }            
        }
    }
    
    func createMoment(actId: String, moment: Moment, newMoment: Bool, completion: @escaping (Error?) -> ()) {
        let act = MainManager.shared.availableActs[actId]
        FireBaseManager.shared.updateMoment(actId: actId, moment: moment, newMoment: true)
        FireBaseManager.shared.updateActionStatus(id: actId, status: Constants.ActionStatus.completed.rawValue)
        FireBaseManager.shared.updateScore(incrementBy: (act?.score)!)
        FireBaseManager.shared.getUser(userID: (User.currentUser?.id)!) { (user, error) in
            if user != nil {
                User.currentUser = user
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MomentCreated"), object: nil)
                completion(nil)
            } else {
                completion(error)
            }
            
        }
        
    }
    
}


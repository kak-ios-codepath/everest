//
//  UserProfileManager.swift
//  Everest
//
//  Created by Kaushik on 10/15/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class UserProfileManager: NSObject {
    
    
    var moments : [Moment]?
    var actions : [Action]?
    var allActs : [Act]?
    var allCategoryTitles : [String]?
    
    
    
    override init() {
        moments = [Moment]()
        allActs = [Act]()
        allCategoryTitles = ["Empathy", "Surprise"]
        
    }
    
    
    func fetchAllActs() {
        for title in allCategoryTitles! {
            FireBaseManager.shared.fetchAvailableActs(category: title, completion: { (acts: [Act]?, error :Error?) in
                if error != nil {
                    
                }
                else {
                    if let acts = acts {
                        for act in acts {
                            self.allActs?.append(act)
                        }
                    }
                }
            })
        }
        
    }
    
    
    func fetchUserActions(userId: String, completion: @escaping (_ actions: [Action]?, _ error : Error?)->()){
        FireBaseManager.shared.getUser(userID: userId) { (user:User?, error:Error?) in
            if user != nil {
                print(user!)
            }
//            var actionsList : [Act]? = [Act]()
//
//            if let userActions = user?.actions {
//                for action in userActions {
//                    for origAction in self.allActs! {
//                        if origAction.id == action.id {
//                            actionsList?.append(origAction)
//                        }
//                    }
//                }
//            }
//            
            completion(user?.actions, error)
        }
    }
    
    
    
    func fetchUserMomments(userId: String, completion: @escaping (_ moments: [Moment]?, _ error : Error?)->()) -> Void{
        
        FireBaseManager.shared.getMomentsTimeLine(startAtMomentId: nil) { (moments:[Moment]?, error:Error?) in
            if moments != nil {
                print(moments!)
            }else if error != nil {
                print(error!)
            }
            completion(moments, error)
        }
    }


}

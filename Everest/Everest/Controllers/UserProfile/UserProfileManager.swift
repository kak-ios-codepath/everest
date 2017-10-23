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
            completion(user?.actions, error)
        }
    }
    
    func fetUserDetails(userId: String, completion: @escaping (_ user: User?, _ error : Error?)->()) -> Void {
        FireBaseManager.shared.getUser(userID: userId) { (user:User?, error:Error?) in
            completion(user, error)
        }
    }
    
    func fetchUserMomments(userId: String, completion: @escaping (_ moments: [Moment]?, _ error : Error?)->()) -> Void{
        var userMoments = [Moment]()
        FireBaseManager.shared.getUser(userID: userId) { (user:User?, error:Error?) in
            if user != nil {
                print(user!)
            }
            var momentsCount = user?.momentIds?.count
            for momentId in (user?.momentIds)! {
                FireBaseManager.shared.getMoment(momentId: momentId, completion: { (moment : Moment?, error: Error?) in
                    if (error == nil ){
                        if let moment = moment {
                            userMoments.append(moment)
                        }
                    }
                    
                    momentsCount = momentsCount! - 1
                    if momentsCount == 0 {
                        completion(userMoments, nil)
                    }
                })
                

            }
        }
    }


}

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
    
    var actionsAndMomentsDataSource:[[String : [Moment]]]?
    
    
    
    override init() {
        moments = [Moment]()
        allActs = [Act]()
        allCategoryTitles = ["Empathy", "Surprise"]
        actionsAndMomentsDataSource = [[String : [Moment]]]()
        
    }    
    
    func fetchAllMomentsForTheUser(user: User?, completion: @escaping (_ completed : Bool, _ error : Error?)->()) {
        
        //TODO: we can revisit this logic
        
        FireBaseManager.shared.fetchMomentsForUser(startAtMomentId: nil, userId: (user?.id)!) { (moments:[Moment]?, error:Error?) in
            
            if let userMoments = moments {
                
                if let actions = user?.actions {
                    for action in actions {
                        var actionMoments = [Moment]()
                        if let mIds = action.momentIds {
                            for mid in mIds {
                                if let momnts = userMoments.filter( { return $0.id == mid } ).first {
                                    actionMoments.append(momnts)
                                }
                            }
                        }
                       self.actionsAndMomentsDataSource?.append([action.id : actionMoments])
                    }
                    
                    completion(true, nil)
                }else {
                    completion(false, nil)
                }
                
            }else {
                if let actions = user?.actions {
                    for action in actions {
                        let actionMoments = [Moment]()
                        self.actionsAndMomentsDataSource?.append([action.id : actionMoments])
                    }
                
                completion(true, nil)
                }else {
                    completion(false, nil)
                }
            }
        }
    }
    
    
    func fetMomentDetail(id:String,  completion: @escaping (_ moment: Moment?, _ error : Error?)->()) {
        FireBaseManager.shared.getMoment(momentId: id) { (moment:Moment?, error:Error?) in
            completion(moment,nil)
        }
    }
    
    func fetchUserActions(userId: String, completion: @escaping (_ actions: [Action]?, _ error : Error?)->()){
        FireBaseManager.shared.getUser(userID: userId) { (user:User?, error:Error?) in
            if user != nil {
                print(user!)
            }
            
            if (user?.actions) != nil {
                completion(user?.actions, nil)
            }
            else {
                completion(nil, NSError(domain: "com.kak.everest", code: 1001, userInfo: nil))
            }
        }
    }
    
    func fetchUserDetails(userId: String, completion: @escaping (_ user: User?, _ error : Error?)->()) -> Void {
        FireBaseManager.shared.getUser(userID: userId) { (user:User?, error:Error?) in
            completion(user, error)
        }
    }
    
//    func fetchMommentsForAction(acttion: Action, completion: @escaping (_ moments: [Moment]?, _ error : Error?)->()) -> Void{
//
//        var userMoments = [Moment]()
//            if (acttion.momentIds) != nil {
//                var momentsCount = acttion.momentIds?.count
//                for momentId in (acttion.momentIds)! {
//                    FireBaseManager.shared.getMoment(momentId: momentId, completion: { (moment : Moment?, error: Error?) in
//                        if (error == nil ){
//                            if let moment = moment {
//                                userMoments.append(moment)
//                            }
//                        }
//                        momentsCount = momentsCount! - 1
//                        if momentsCount == 0 {
//                            completion(userMoments, nil)
//                        }
//                    })
//                }
//            }
//            else {
//                completion(nil, NSError(domain: "com.kak.everest", code: 1001, userInfo: nil))
//            }
//        }
    


}

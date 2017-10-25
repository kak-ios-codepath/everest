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
    
    
    func fetchAllMomentsForTheUser(user: User?, completion: @escaping (_ completed : Bool, _ error : Error?)->()) {
        
        //TODO: we can revisit this logic
        
//        FireBaseManager.shared.fetchMomentsForUser(startAtMomentId: nil, userId: (user?.id)!) { (moments:[Moment]?, error:Error?) in
//            print("\(moments?.count)")
//            completion(true,nil)
//            return
//        }
        
        

 /*       if (user?.actions?.count)! > 0 {
            
//            let dispatchGroup = DispatchGroup()

            for action in (user?.actions)! {
//                dispatchGroup.enter()
                var momentsOfAction = [Moment]()
                print("act id \(action.id)")
                if let momentIds = action.momentIds {
                    
//                    dispatchGroup.enter()

                    for momentId in momentIds {
                        let sem = DispatchSemaphore(value: 0)

                        FireBaseManager.shared.getMoment(momentId: momentId, completion: { (moment : Moment?, error: Error?) in
                            if moment != nil {
                                print("\(moment?.title)")
                                momentsOfAction.append(moment!)
                            }
                            //sem.signal()
                            
//                            dispatchGroup.leave()
                        })
                        
                        //sem.wait()
                    }
                }
 //               self.actionsAndMomentsDataSource?.append([action.id : momentsOfAction])
                
//                dispatchGroup.leave()

            }

//            completion(true,nil)

//            dispatchGroup.notify(queue: .main) {
//                print("Action and its moments are complete 👍")
//            }
        }*/
        
        
        
        
//        FireBaseManager.shared.fetchMomentsForUser(startAtMomentId: nil, userId: (user?.id)!) { (moments: [Moment]?, error: Error?) in
//            if let userMoments = moments {
//                if (user?.actions?.count)! > 0 {
//                    var momentsOfAction = [Moment]()
//                    for action in (user?.actions)! {
//                        if let momentIds = action.momentIds {
//                            for momentId in momentIds {
//                                for moment in userMoments {
//                                    if moment.id == momentId {
//                                        momentsOfAction.append(moment)
//                                    }
//                                }
//                            }
//                        }
//                        
//                        self.actionsAndMomentsDataSource?.append([action.id : momentsOfAction])
//                    }
//                    
//                    completion(true,nil)
//                }
//
//            }
//            
//        }
//        
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
    
//    func fetchUserMomments(userId: String, completion: @escaping (_ moments: [Moment]?, _ error : Error?)->()) -> Void{
//        var userMoments = [Moment]()
//        FireBaseManager.shared.getUser(userID: userId) { (user:User?, error:Error?) in
//            if user != nil {
//                print(user!)
//            }
//            
//            if (user?.momentIds) != nil {
//                var momentsCount = user?.momentIds?.count
//                for momentId in (user?.momentIds)! {
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
//    }


}

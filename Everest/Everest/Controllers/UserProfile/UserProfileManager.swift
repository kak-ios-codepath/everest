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
    
    override init() {
        moments = [Moment]()
    }
    
    func fetchUserActions(userId: String, completion: @escaping (_ actions: [Action]?, _ error : Error?)->()){
        FireBaseManager.shared.getUser(userID: "uQxn19H3VdgLPV16NxHqUn6zy7B3") { (user:User?, error:Error?) in
            if user != nil {
                print(user!)
            }
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

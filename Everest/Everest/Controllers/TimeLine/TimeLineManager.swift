//
//  TimeLineManager.swift
//  Everest
//
//  Created by Kaushik on 10/14/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class TimeLineManager: NSObject {
    
    var moments : [Moment]?
    
    override init() {
        moments = [Moment]()
    }
    
    func fetchUserDetails(completion: @escaping (_ user: User?, _ error : Error?)->()){
        FireBaseManager.shared.getUser(userID: "uQxn19H3VdgLPV16NxHqUn6zy7B3") { (user:User?, error:Error?) in
            print("%@",user)
        }
    }
    

    
    func fetchPublicMomments(completion: @escaping (_ moments: [Moment]?, _ error : Error?)->()) -> Void{
        
        FireBaseManager.shared.getMomentsTimeLine(startAtMomentId: nil) { (moments:[Moment]?, error:Error?) in
            print("%@",moments)
            print("error %@",error)
            completion(moments, error)
        }
    }
    
    
}

//
//  MomentDetailManager.swift
//  Everest
//
//  Created by Kaushik on 10/15/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class MomentDetailManager: NSObject {

    
    var moments : [Moment]?

    
    override init() {
        moments = [Moment]()
    }
    
    
    func fetchDetailsOfTheMoment(momentId: String, completion: @escaping (_ moment: Moment?, _ error : Error?)->()){
        FireBaseManager.shared.getMoment(momentId: momentId) { (moment:Moment?, error:Error?) in
            completion(moment, error)
        }
    }
    
    
    func fetchSuggestedMoments(momentId: String,completion: @escaping (_ moments: [Moment]?, _ error : Error?)->()) {
        //FireBaseManager.shared.
    }
    
}

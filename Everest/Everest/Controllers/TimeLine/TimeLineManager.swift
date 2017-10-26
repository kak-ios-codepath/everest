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
    
    
    func fetchPublicMomments(completion: @escaping (_ moments: [Moment]?, _ error : Error?)->()) -> Void{
        
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

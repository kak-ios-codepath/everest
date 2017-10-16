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
        ServiceManager.sharedInstance.get(request: nil) { (response: Any?, error: Error?) in
                completion(nil,nil);
        }
    }
    
    
}

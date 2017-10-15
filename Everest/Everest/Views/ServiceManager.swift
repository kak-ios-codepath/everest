//
//  ServiceManager.swift
//  Everest
//
//  Created by Kaushik on 10/14/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//



/*
 
 This class is a global manager class which is responsible for handling any network requests or responses. 
 For now we can use this class to talk to firebase and fetch the data.
 */

import UIKit

class ServiceManager: NSObject {
    
    class var sharedInstance : ServiceManager {
        struct Static {
            static let instance = ServiceManager.init()
        }
        
        return Static.instance
    }
    

    func get(request:URLRequest?,completion: @escaping (_ response: Any?, _ error : Error?)->()) -> Void{
        
    }
    
}

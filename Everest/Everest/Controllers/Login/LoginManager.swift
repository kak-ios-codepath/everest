//
//  LoginManager.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/18/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

class LoginManager {
    
    static let shared = LoginManager()
    
    func registerUser(name: String, email: String, password: String, completion: @escaping (NSError?) -> ()) {
        FireBaseManager.shared.registerNewUserWithEmail(name: name, email: email, password: password) { (user, error) in
            if error != nil {                
                print ("ERROR: \(error.debugDescription)")
            }
            completion(error)
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (NSError?) -> ()) {
        FireBaseManager.shared.loginUserWithEmail(email: email, password: password) { (user, error) in
            if error != nil {
                print ("ERROR: \(error.debugDescription)")
            }
            completion(error as NSError?)
        }
    }

    func loginUserWithFacebook(token: AccessToken, completion: @escaping (NSError?) -> ()) {
        FireBaseManager.shared.loginUserWithFacebook(accessToken: token.authenticationToken, completion: { (user, error) in
            if error != nil {
                print ("ERROR: \(error.debugDescription)")
            }
            completion(error as NSError?)
        })
    }

    func logoutUser(completion: @escaping (NSError?) -> () ) {
        FireBaseManager.shared.logoutUser() { (error) in
            if error != nil {
                print ("ERROR: \(error.debugDescription)")
            }
            //TODO: This is a hack for FB
            AccessToken.current = nil
            UserProfile.current = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoggedOut"), object: nil)
            completion(error as NSError?)
        }
    }
}

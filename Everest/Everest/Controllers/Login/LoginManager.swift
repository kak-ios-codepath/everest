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
import Firebase
class LoginManager {
    
    static let shared = LoginManager()
    
    func initialize() {
        if let uid = Auth.auth().currentUser?.uid {
            print("User is logged in = \(uid)")
            
            FireBaseManager.shared.getUser(userID: uid) { (user, error) in
                if user != nil {
                    User.currentUser = user
                } else {//user doesn't exist
                    //This should NEVER happen. Force logout
                    self.logoutUser { (error) in
                        //TODO: Handle error
                    }
                }
            }
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoggedOut"), object: nil)
        }
    }
    
    func isUserLoggedIn() -> Bool {
        if ((Auth.auth().currentUser?.uid) != nil) {
            return true
        } else {
            return false
        }
    }
    
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
            User.currentUser = user
            completion(error as NSError?)
        }
    }

    func loginUserWithFacebook(token: AccessToken, completion: @escaping (NSError?) -> ()) {
        FireBaseManager.shared.loginUserWithFacebook(accessToken: token.authenticationToken, completion: { (user, error) in
            if error != nil {
                print ("ERROR: \(error.debugDescription)")
            }
            User.currentUser = user
            completion(error as NSError?)
        })
    }

    func logoutUser(completion: @escaping (NSError?) -> () ) {
        FireBaseManager.shared.logoutUser() { (error) in
            if error != nil {
                print ("ERROR: \(error.debugDescription)")
            }
            User.currentUser = nil
            //TODO: This is a hack for FB
            AccessToken.current = nil
            UserProfile.current = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoggedOut"), object: nil)
            completion(error as NSError?)
        }
    }
}

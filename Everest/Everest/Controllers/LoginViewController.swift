//
//  LoginViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FacebookShare

class LoginViewController: UIViewController, LoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //adding FB login button programmatically
        let loginButton = LoginButton(readPermissions: [ .publicProfile,  .email, .userFriends  ])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            print("User is logged in -- \(accessToken.userId!)")
        } else {
            print("User is NOT logged in ")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Facebook Login delegates
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("Login complete.....")
    }
    
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logout complete.....")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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

    
    @IBOutlet weak var fbLoginView: UIView!
    var fbLoginButton: LoginButton!
    
    @IBAction func loginViaEmailAction(_ sender: AnyObject) {
        print("Login via email action ")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //adding FB login button programmatically
        fbLoginButton = LoginButton(readPermissions: [ .publicProfile,  .email, .userFriends  ])
        fbLoginButton.frame = fbLoginView.bounds
        fbLoginButton.delegate = self
        fbLoginView.addSubview(fbLoginButton)
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
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("Cancelled")
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            //TODO: Create a new user on Firebase based on thise token
            print("Logged In")
            print (grantedPermissions)
            print (declinedPermissions)
            print (accessToken)
        }
        
        self.dismiss(animated: true) {
            
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        //TODO: Logout current user from the app.
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

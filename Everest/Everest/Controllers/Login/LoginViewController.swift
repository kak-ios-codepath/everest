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

class LoginViewController: UIViewController, LoginButtonDelegate, EmailLoginDelegate {

    
    @IBOutlet weak var fbLoginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //adding FB login button programmatically
        let fbLoginButton = LoginButton(readPermissions: [ .publicProfile,  .email, .userFriends  ])
        fbLoginButton.frame = fbLoginView.bounds
        fbLoginButton.delegate = self
        fbLoginView.addSubview(fbLoginButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func userLoggedIn() {
        print("Transition to main app.....")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        UIApplication.shared.delegate?.window??.rootViewController = vc
    }
    
    func userLoggedOut() {
        LoginManager.shared.logoutUser { (error) in
            //TODO: Handle error
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    // MARK: - Facebook Login delegates
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
            case .failed(let error):
                print(error)
                break
            case .cancelled:
                print("Cancelled")
                break
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                //TODO: Create a new user on Firebase based on thise token
                print("Logged In via Facebook")
                print (grantedPermissions)
                print (declinedPermissions)
                print (accessToken)
                LoginManager.shared.loginUserWithFacebook(token: accessToken, completion: { (error) in
                    if error == nil {
                        self.userLoggedIn()
                    }
                })
            }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Facebook logout complete.....")
        self.userLoggedOut()
    }

    // MARK: - Email Login delegates
    
    func didCompleteEmailLogin() {
        print("Logged In via Email")
        self.userLoggedIn()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "emailLoginModalViewController") {
            let controller = segue.destination as! EmailLoginViewController
            controller.delegate = self
        }
    }
    


}

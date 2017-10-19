//
//  EmailLoginViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/17/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

public enum EmailLoginResult {
    /// User succesfully logged in. Contains access token.
    case success
    /// Login attempt was cancelled by the user.
    case cancelled
    /// Login attempt failed.
    case failed
}

public protocol EmailLoginDelegate {
    func didCompleteEmailLogin(result: EmailLoginResult)
    func didCompleteEmailLogOut()
}

class EmailLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    public var delegate: EmailLoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loginUser() {
        LoginManager.shared.loginUser(email: self.emailTextField.text!, password: self.passwordTextField.text!) { (error) in
            var result: EmailLoginResult = .success
            if error != nil {
                result = .failed
            }
            self.dismiss(animated: true, completion: nil)
            if self.delegate != nil {
                self.delegate?.didCompleteEmailLogin(result: result)
            }
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        self.loginUser()
    }
    
    
    @IBAction func signupClicked(_ sender: Any) {
        //register new user by email
        //TODO: replace the name 
        LoginManager.shared.registerUser(name: emailTextField.text!, email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            var result: EmailLoginResult = .success
            if error != nil {
                result = .failed
                self.dismiss(animated: true, completion: nil)
                if self.delegate != nil {
                    self.delegate?.didCompleteEmailLogin(result: result)
                }
            }else {
                self.loginUser()
            }
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if self.delegate != nil {
            self.delegate?.didCompleteEmailLogin(result: .cancelled)
        }
    }
}

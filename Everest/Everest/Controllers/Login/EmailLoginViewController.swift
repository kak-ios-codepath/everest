//
//  EmailLoginViewController.swift
//  Everest
//
//  Created by Kavita Gaitonde on 10/17/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

public protocol EmailLoginDelegate {
    func didCompleteEmailLogin()
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
            if error != nil {
                self.showAlert(message: error!.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
                if self.delegate != nil {
                    self.delegate?.didCompleteEmailLogin()
                }
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
            if error != nil {
                self.showAlert(message: error!.localizedDescription)
            }else {
                self.loginUser()
            }
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message,  preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action:UIAlertAction!) in
        })
        alertController.addAction(okAction)
        // Present Alert
        self.present(alertController, animated: true, completion:nil)

    }
}

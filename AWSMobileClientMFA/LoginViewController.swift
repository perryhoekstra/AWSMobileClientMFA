//
//  LoginViewController.swift
//  AWSMobileClientMFA
//
//  Created by Perry Hoekstra on 11/8/19.
//  Copyright © 2019 Perry Hoekstra. All rights reserved.
//

import Foundation
import UIKit
import AWSMobileClient
import JGProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let hud = JGProgressHUD(style: .dark)
    
    @IBAction func loginTap(_ sender: Any) {
        hud.textLabel.text = "Logging in ..."
        hud.show(in: self.view)
        
        if let username = emailAddressTextField.text, let password = passwordTextField.text {
            AWSMobileClient.sharedInstance().signIn(username: username, password: password) { (signInResult, error) in
                self.hud.dismiss(afterDelay: 0.5)
                
                DispatchQueue.main.async {
                    if let error = error  {
                        self.showError(error: error)
                    }
                    else if let signInResult = signInResult {
                        switch (signInResult.signInState) {
                            case .signedIn:
                                self.showSignInError(signInResult: signInResult)
                            case .smsMFA:
                                self.showSMSModal(message: "SMS message sent to \(signInResult.codeDetails!.destination!)")
                            default:
                                self.showSignInError(signInResult: signInResult)
                        }
                    }
                }
            }
        }
    }
    
    func mfaSuccess() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                         
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "Main") as! MainViewController
        
        UIApplication.shared.keyWindow?.rootViewController = mainViewController
    }
    
    func showError(error: Error) {
        let alertController = UIAlertController(title: "Login Error", message: "There was an error with your login: " + error.localizedDescription, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showSignInError(signInResult: SignInResult) {
        switch (signInResult.signInState) {
            case .signedIn:
                 let alertController = UIAlertController(title: "Login", message: "You have logged in but there is no phone number associated your account for MFA", preferredStyle: .alert)

                 alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                           
                self.present(alertController, animated: true, completion: nil)
            default:
                let alertController = UIAlertController(title: "Login Error", message: "There was an error with your login, please contact user support", preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                           
                self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showSMSModal(message: String) {
        let mfaModalStoryboard = UIStoryboard(name: "MFAModal", bundle: nil)
        
        let mfaModalViewController = mfaModalStoryboard.instantiateViewController(withIdentifier: "MFAModal") as! MFAModalViewController
        
        mfaModalViewController.modalPresentationStyle = .overCurrentContext
        mfaModalViewController.message = message
        mfaModalViewController.loginViewController = self
        
        if let emailAddress = emailAddressTextField.text {
            mfaModalViewController.emailAddress = emailAddress
        }
        
        self.present(mfaModalViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LoginViewController")
    }
}

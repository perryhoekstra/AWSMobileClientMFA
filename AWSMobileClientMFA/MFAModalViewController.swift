//
//  MFAModalViewController.swift
//  Tempore
//
//  Created by Travel Labs MacBook Pro on 11/3/19.
//  Copyright © 2019 Travel Labs. All rights reserved.
//

import Foundation
import UIKit
import AWSMobileClient
import AWSCognitoIdentityProvider
import JGProgressHUD

class MFAModalViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var mfaTextField: UITextField!
    
    private let hud = JGProgressHUD(style: .dark)
    public var message: String?
    public var emailAddress: String?
    public var loginViewController: LoginViewController?
    var mfaCompletionSource: AWSTaskCompletionSource<NSString>?
    
    func handleConfirmation(signInResult: SignInResult?, error: Error?) {
        if error != nil {
            print("Confirmation error: ", error)
            
            let alertController = UIAlertController(title: "Cannot Verify Code",
                                                           message: (error! as NSError).userInfo["message"] as? String,
                                                           preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion:  nil)
        }
        else {
            guard let signInResult = signInResult else {
                return
            }
                   
            switch(signInResult.signInState) {
                case .signedIn:
                    print("User is signed up and confirmed.")
                       
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        
                        if let loginViewController = self.loginViewController {
                            loginViewController.mfaSuccess()
                        }
                    }
                
                    break
            
                case .smsMFA:
                    print("smsMFA case")
                
                    break
            
                case .passwordVerifier:
                    print("passwordVerifier case")
                
                    break
            
                case .customChallenge:
                    print("customChallenge case")
                
                    break
            
                case .deviceSRPAuth:
                    print("deviceSRPAuth case")
                
                    break
            
                case .devicePasswordVerifier:
                    print("devicePasswordVerifier case")
                
                    break
            
                case .adminNoSRPAuth:
                    print("adminNoSRPAuth case")
                
                    break
            
                case .newPasswordRequired:
                    print("newPasswordRequired case")
            
                    break
            
                default:
                    print("Unexpected case")
            }
        }
    }
    
    @IBAction func mfaTextFieldChanged(_ sender: Any) {
        if let mfaCode = mfaTextField.text, mfaCode.count == 6, let emailAddress = emailAddress {
            hud.textLabel.text = "Validating MFA"
            hud.show(in: self.view)
            
            AWSMobileClient.sharedInstance().confirmSignIn(challengeResponse: mfaCode) { (signInResult, error) in
                self.hud.dismiss(afterDelay: 0.5)
                                                               
                DispatchQueue.main.async {self.handleConfirmation(signInResult: signInResult, error: error)}
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        boxView.backgroundColor = UIColor.white
        
        if let message = message {
            messageLabel.text = message
        }
    }
}

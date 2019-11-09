//
//  MainViewController.swift
//  AWSMobileClientMFA
//
//  Created by Perry Hoekstra on 11/8/19.
//  Copyright © 2019 Perry Hoekstra. All rights reserved.
//

import UIKit
import AWSMobileClient

class MainViewController: UIViewController {
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBAction func signOutTap(_ sender: Any) {
        AWSMobileClient.sharedInstance().signOut()
        
        let alertController = UIAlertController(title: "Sign Out", message: "You are now signed out", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
            self.signOutButton.backgroundColor = UIColor.gray
            self.signOutButton.setTitleColor(.lightGray, for: .normal)
            self.signOutButton.isEnabled = false
        })
                   
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MainViewController")
    }


}


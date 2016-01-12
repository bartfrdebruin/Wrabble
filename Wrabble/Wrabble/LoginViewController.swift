//
//  LoginViewController.swift
//  Wrabble
//
//  Created by Marina Huber on 1/8/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse
import AVFoundation


class LoginViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var emailLogin: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var blur: UIVisualEffectView!
    @IBOutlet var warningLogin: UIView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLogin.delegate = self
        self.password.delegate = self
        self.warningLogin.hidden = true
        self.blur.hidden = true
        self.navigationController?.setToolbarHidden(true, animated: true)
        emailLogin.placeholder = "Username..."
        password.placeholder = "Password..."

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissWarning(sender: AnyObject) {
        
        self.warningLogin.hidden = true
        self.blur.hidden = true
        
    }
    @IBAction func login(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(emailLogin.text!, password:password.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                let home = TableViewController()
                self.navigationController?.pushViewController(home, animated: true)
            } else {
                // The login failed. Check error to see why.
                self.warningLogin.hidden = false
                self.blur.hidden = false
                
            }
        }
    }
 
    @IBAction func signup(sender: UIButton) {
        
        let lc = SignupViewController(nibName: "SignupViewController", bundle: nil)
        
        self.navigationController!.pushViewController (lc, animated: false)
    }

   func textFieldShouldReturn(textField: UITextField) -> Bool  {
     emailLogin.resignFirstResponder()
     password.resignFirstResponder()
        
     return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

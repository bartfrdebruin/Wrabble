//
//  SignupViewController.swift
//  Wrabble
//
//  Created by Marina Huber on 1/8/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var littleView: UIView!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        
        username.placeholder = "Username..."
        username.textColor = UIColor.blackColor()
        email.placeholder = "Email..."
        email.textColor = UIColor.blackColor()
        password.placeholder = "Password..."
        password.textColor = UIColor.blackColor()


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)

        UIView.animateWithDuration(3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 8, options: .AllowUserInteraction, animations: { () -> Void in
            self.littleView.frame = self.view.frame
            
            }, completion: nil)    }
    
    @IBAction func signUp(sender: AnyObject) {
        [self .mySignUp()]
    }
    
    func mySignUp() {
        let user = PFUser()
        user.username = email.text
        user.password = password.text
        user.email = email.text
    
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool  {
        username.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

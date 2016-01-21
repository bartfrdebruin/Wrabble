//
//  SignupViewController.swift
//  Wrabble
//
//  Created by Marina Huber on 1/8/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse

protocol Done {
    func done()
}

class SignupViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet var littleView: UIView!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var email: UITextField!
    var delegate:Done?
    
    
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
        
//        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 8, options: .AllowUserInteraction, animations: { () -> Void in
            self.littleView.frame = self.view.frame
            
//            }, completion: nil)   
    }
    
    @IBAction func signUp(sender: AnyObject) {
        self.mySignUp()
    }
    
    func mySignUp() {
        delegate?.done()
        let user = PFUser()
        user.username = email.text
        user.password = password.text
        user.email = email.text
        user["mash"] = []
        let image = UIImage(named: "slide")
        let data = UIImageJPEGRepresentation(image!, 0.5)
        let file = PFFile(data: data!)
        user["image"] = file
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if (error != nil) {
                let errorString = error!.userInfo["error"] as? NSString
            } else {
                let object = PFObject(className: "followers")
                object["userID"] = PFUser.currentUser()?.objectId
                object["followers"] = []
                object["following"] = []
                object.saveInBackgroundWithBlock({ (done, error) -> Void in
                    let tabbar = TabViewController()
                    self.presentViewController(tabbar, animated: true, completion: nil)                })
            }
        }
    }
    
    func done() {
        print("done")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool  {
        username.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()
        
        return true
    }
    
}

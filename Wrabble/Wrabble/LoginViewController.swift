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


class LoginViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var emailLogin: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var oops: UILabel!
    @IBOutlet var closeButton: UIButton!
    var lc = SignupViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.emailLogin.delegate = self
        self.password.delegate = self
        self.oops.hidden = true
        self.closeButton.hidden = true
        self.navigationController?.setToolbarHidden(true, animated: true)
        emailLogin.placeholder = "Username..."
        password.placeholder = "Password..."
    }
    
    @IBAction func dismissWarning(sender: AnyObject) {
        
        self.oops.hidden = true
        self.closeButton.hidden = true
        self.view.subviews.last?.removeFromSuperview()
        self.view.subviews.last?.removeFromSuperview()
        self.view.subviews.last?.removeFromSuperview()
    

        
    }
    @IBAction func login(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(emailLogin.text!, password:password.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.startTab()
            } else {
                // The login failed. Check error to see why.
                self.oops.hidden = false
                self.closeButton.hidden = false
                //bluring background
                let blurEffect = UIBlurEffect(style: .Light)
                // 2
                let blurView = UIVisualEffectView(effect: blurEffect)
                // 3
                blurView.frame = self.view.bounds
                
                self.view.addSubview(blurView)
                self.view.addSubview(self.oops)
                self.view.addSubview(self.closeButton)
                
            }
        }
    }
    
    func startTab() {
        let tabbar = TabViewController()
        self.presentViewController(tabbar, animated: true, completion: nil)
    }
 
    @IBAction func signup(sender: UIButton) {
        self.view.addSubview(lc.view)
        let animate = CABasicAnimation(keyPath: "position.y")
        animate.fromValue = 600
        animate.toValue = self.view.center.y
        lc.view.layer.addAnimation(animate, forKey: "")
        let fading = CABasicAnimation(keyPath: "opacity")
        fading.duration = 0.4
        fading.fromValue = 0
        fading.toValue = 1
        fading.fillMode = kCAFillModeForwards
        fading.removedOnCompletion = false
        lc.view.layer.addAnimation(fading, forKey: "alpha")
        let sign = lc.view.viewWithTag(1) as! UIButton
        sign.addTarget(self, action: "mySignup", forControlEvents: .TouchUpInside)
    }

    func mySignup() {
        lc.mySignUp()
    }
    
    
    
   func textFieldShouldReturn(textField: UITextField) -> Bool  {
     emailLogin.resignFirstResponder()
     password.resignFirstResponder()
        
     return true
    }

}

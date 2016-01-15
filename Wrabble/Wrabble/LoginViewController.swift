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
        self.navigationController?.pushViewController(tabbar, animated: true)
    
    }
 
    @IBAction func signup(sender: UIButton) {
        
       let lc = SignupViewController()
//        let animate = CABasicAnimation(keyPath: "position.y")
//        animate.toValue = self.view.center.y
//        animate.fromValue = 600
//        lc.view.layer.addAnimation(animate, forKey: "")
//        let fading = CABasicAnimation(keyPath: "opacity")
//        fading.duration = 0.4
//        fading.fromValue = 1
//        fading.toValue = 0
//        fading.fillMode = kCAFillModeForwards
//        fading.removedOnCompletion = false
//        lc.view.layer.addAnimation(fading, forKey: "alpha")
        let spring = CASpringAnimation (keyPath: "position.y")
        spring.damping = 7
        spring.fromValue = 200
        spring.toValue = 3
        lc.view.layer.addAnimation(spring, forKey: "spring")
        self.view.addSubview(lc.view)
      

    }

   func textFieldShouldReturn(textField: UITextField) -> Bool  {
     emailLogin.resignFirstResponder()
     password.resignFirstResponder()
        
     return true
    }

}

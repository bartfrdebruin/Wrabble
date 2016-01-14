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
                // sharp dismiss view
//                blurView.contentView.addSubview(self.oops)
                self.view.addSubview(blurView)
                self.view.addSubview(self.oops)
                self.view.addSubview(self.closeButton)
                
            }
        }
    }
    
    func startTab() {
        let tabbar = UITabBarController()
        let home = UserViewController()
        let homeN = UINavigationController(rootViewController: home)
        
        let table = TableViewController()
        let tableN = UINavigationController(rootViewController: table)
        
        let rec = FirstViewController()
        let recN = UINavigationController(rootViewController: rec)
        
        let im2 = UIImage(named: "second")
        home.tabBarItem.image = im2
        let im3 = UIImage(named: "slide")
        table.tabBarItem.image = im3
        let im4 = UIImage(named: "first")
        rec.tabBarItem.image = im4
        
        tabbar.viewControllers = [homeN, tableN,recN]
        for viewC in tabbar.viewControllers! as! [UINavigationController]{
            viewC.navigationBarHidden = true
        }
        self.navigationController?.pushViewController(tabbar, animated: true)
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

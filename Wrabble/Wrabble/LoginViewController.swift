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
        self.tabBarController?.tabBar.hidden = true
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
                self.startTab()
            } else {
                // The login failed. Check error to see why.
                self.warningLogin.hidden = false
                self.blur.hidden = false
                
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

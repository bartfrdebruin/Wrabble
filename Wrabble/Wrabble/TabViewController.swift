//
//  TabViewController.swift
//  Wrabble
//
//  Created by Eyolph on 13/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse

class TabViewController: UITabBarController, UIGestureRecognizerDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var item1: UIViewController!
    @IBOutlet weak var item2: UIViewController!
    var longPress : UIGestureRecognizer
    var sel : Bool?
    var keep : UIView!
    var test : UIView!
    var url : NSURL?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        longPress = UIGestureRecognizer()
        super.init(nibName: "TabViewController", bundle: nil)
        longPress = UILongPressGestureRecognizer(target: self, action: "pressed")

        let home = UserViewController()
        let homeN = UINavigationController(rootViewController: home)
        
        let table = TableViewController()
        let tableN = UINavigationController(rootViewController: table)
        
        let rec = FirstViewController()
        let recN = UINavigationController(rootViewController: rec)
        
        let im2 = UIImage(named: "second")
        homeN.tabBarItem.image = im2
        homeN.tabBarItem.tag = 1

        let im3 = UIImage(named: "slide")
        tableN.tabBarItem.image = im3
        tableN.tabBarItem.tag = 2

        let im4 = UIImage(named: "first")
        recN.tabBarItem.image = im4
        recN.tabBarItem.tag = 3
        self.viewControllers = [homeN, recN, tableN]
        self.delegate = self
        longPress.delegate = self
        self.tabBar.addGestureRecognizer(longPress)
        for viewC in self.viewControllers! as! [UINavigationController]{
            viewC.navigationBarHidden = true
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (self.sel == true) {
            return true
        } else {
            return false
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController.tabBarItem.tag == 3) {
            return false
        } else {
            return true
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
         if (viewController.tabBarItem.tag == 3) {
        }
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if (item.tag == 3) {
            self.sel = true
            addView()
        } else {
            self.sel = false
        }
    }
    
    func pressed() {
        if (longPress.state == .Began) {
        let spin = SpinLoading(frame: CGRectMake(180, 180, 60, 60))
        self.selectedViewController?.view.addSubview(spin)
            spin.animate(120)
            keep.removeFromSuperview()
            let recorder = Recorder()
            url = recorder.recordWithPermission(true) 
            
        } else if (longPress.state == .Ended) {
        self.selectedViewController?.view.subviews.last?.removeFromSuperview()
            setSave()
        }
    }
    
    func addView() {
        keep = NSBundle.mainBundle().loadNibNamed("KeepPressed", owner: self, options: nil).last as! UIView
        keep!.alpha = 0
        keep.layer.cornerRadius = 20
        keep!.frame = CGRectMake(0, self.view.frame.size.height - (self.tabBar.frame.height + 80), self.view.frame.size.width, 80)
        self.view.addSubview(keep)
        UIView.animateWithDuration(1, delay: 0, options: .Autoreverse, animations: { () -> Void in
            self.keep.alpha = 1
            }) { (done) -> Void in
                self.keep.alpha = 0
                self.keep.removeFromSuperview()
        }
    }
    
    func setSave() {
        let test = TestViewController()
        self.view.addSubview(test.view)
        let animate = CABasicAnimation(keyPath: "position.y")
        animate.fromValue = 800
        animate.toValue = self.view.center.y
        test.view.layer.addAnimation(animate, forKey: "ciao")
        let backButton = test.view.viewWithTag(1) as! UIButton
        backButton.addTarget(self, action: "remove", forControlEvents: .TouchUpInside)
        let saveBn = test.view.viewWithTag(2) as! UIButton
        saveBn.addTarget(self, action: "saveRecord", forControlEvents: .TouchUpInside)

    }
    
    func saveRecord(){
        let data = NSData(contentsOfURL: self.url!)
        let name = self.view.subviews[self.view.subviews.count - 1].viewWithTag(3) as! UITextField
        name.userInteractionEnabled = true
        
        let file = PFFile(name: name.text, data: data!)
        let object = PFObject(className: "Wrabbles")
        object["rec"] = file
        object["userID"] = PFUser.currentUser()?.objectId
        object["username"] = PFUser.currentUser()?.username
        object["name"] = name.text
        
        object.saveInBackgroundWithBlock { (succeed, Error) -> Void in
            if (succeed == true) {
                self.remove()
            } else {
                print (Error!.userInfo["error"])
            }
        }
    }
    
    func remove() {
        test =  self.view.subviews[self.view.subviews.count - 1]
        test.layer.removeAllAnimations()
        let animate = CABasicAnimation(keyPath: "position.y")
        animate.fromValue = self.view.center.y
        animate.toValue = 800
        animate.delegate = self
        let fading = CABasicAnimation(keyPath: "opacity")
        fading.duration = 0.2
        fading.fromValue = 1
        fading.toValue = 0
        fading.fillMode = kCAFillModeForwards
        fading.removedOnCompletion = false
        test.layer.addAnimation(animate, forKey: "ciao")
        test.layer.addAnimation(fading, forKey: "alpha")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        test.removeFromSuperview()
        self.selectedViewController?.reloadInputViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

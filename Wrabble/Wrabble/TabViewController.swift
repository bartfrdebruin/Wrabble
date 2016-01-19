//
//  TabViewController.swift
//  Wrabble
//
//  Created by Eyolph on 13/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse
import AudioToolbox
import AVFoundation

class TabViewController: UITabBarController, UIGestureRecognizerDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var item1: UIViewController!
    @IBOutlet weak var item2: UIViewController!
    var longPress : UIGestureRecognizer
    var sel : Bool?
    var keep : UIView!
    var test : UIView!
    var url : NSURL?
    var spin : SpinLoading!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        longPress = UIGestureRecognizer()
        super.init(nibName: "TabViewController", bundle: nil)
        longPress = UILongPressGestureRecognizer(target: self, action: "pressed")

        let home = UserViewController()
        let homeN = UINavigationController(rootViewController: home)
        let im2 = UIImage(named: "second")
        homeN.tabBarItem.image = im2
        homeN.tabBarItem.tag = 1
        homeN.tabBarItem.title = "user"
        
        let table = TableViewController()
        let tableN = UINavigationController(rootViewController: table)
        let im3 = UIImage(named: "second")
        tableN.tabBarItem.image = im3
        tableN.tabBarItem.tag = 2
        tableN.tabBarItem.title = "all"
        
        let rec = FirstViewController()
        let recN = UINavigationController(rootViewController: rec)

        let im4 = UIImage(named: "second")
        recN.tabBarItem.image = im4
        recN.tabBarItem.tag = 3
        recN.tabBarItem.title = "record"
        
        let all = AllPeopleViewController()
        let allN = UINavigationController(rootViewController: all)
        
        let im5 = UIImage(named: "second")
        allN.tabBarItem.image = im5
        allN.tabBarItem.tag = 4
        allN.tabBarItem.title = "all People"
        
        self.viewControllers = [homeN, recN, tableN, allN]
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
            spin = SpinLoading(frame: CGRectMake(180, 180, 60, 60))
        self.selectedViewController?.view.addSubview(spin)
            spin.animate(120)
            let recorder = Recorder()
            recorder.record()
            url = recorder.soundFileURL
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        } else if (longPress.state == .Ended) {
            let recorder = Recorder()
            recorder.stop()
            setSave()
        }
    }
    
    func addView() {
        keep = NSBundle.mainBundle().loadNibNamed("KeepPressed", owner: self, options: nil).last as! UIView
        keep.layer.removeAllAnimations()
        keep.layer.cornerRadius = 20
        keep!.frame = CGRectMake(0, 0, self.view.frame.size.width, 80)
        if (longPress.state != .Began) {
        self.view.addSubview(keep)
        }
        let animate = CABasicAnimation(keyPath: "position.y")
        animate.duration = 1.2
        animate.fromValue = self.view.frame.size.height
        animate.toValue = self.view.frame.size.height - (self.tabBar.frame.height)
        animate.delegate = self
        let fading = CABasicAnimation(keyPath: "opacity")
        fading.duration = 1
        fading.fromValue = 1
        fading.toValue = 0
        fading.fillMode = kCAFillModeForwards
        fading.removedOnCompletion = false
        keep.layer.addAnimation(animate, forKey: "incoming")
        keep.layer.addAnimation(fading, forKey: "alpha")
        keep.layer.position = CGPointMake(self.view.center.x, self.view.frame.size.height - (self.tabBar.frame.height))
    }
    
    func setSave() {
        let test = NSBundle.mainBundle().loadNibNamed("Test", owner: self, options: nil).last as! UIView
        self.view.addSubview(test)
        let animate = CABasicAnimation(keyPath: "position.y")
        animate.fromValue = self.view.frame.size.height
        animate.duration = 0.6
        animate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animate.toValue = self.view.center.y
        test.layer.addAnimation(animate, forKey: "incoming")
        test.layer.position = CGPointMake(self.view.center.x, self.view.center.y)
        let backButton = test.viewWithTag(1) as! UIButton
        backButton.addTarget(self, action: "remove", forControlEvents: .TouchUpInside)
        let saveBn = test.viewWithTag(2) as! UIButton
        saveBn.addTarget(self, action: "saveRecord", forControlEvents: .TouchUpInside)
        self.tabBar.userInteractionEnabled = false
    }
    
    func saveRecord(){
        let data = NSData(contentsOfURL: self.url!)
        let name = self.view.subviews[self.view.subviews.count - 1].viewWithTag(3) as! UITextField
        name.userInteractionEnabled = true
        self.tabBar.userInteractionEnabled = true

        let file = PFFile(name: name.text, data: data!)
        let object = PFObject(className: "Wrabbles")
        object["rec"] = file
        object["userID"] = PFUser.currentUser()?.objectId
        object["username"] = PFUser.currentUser()?.username
        object["name"] = name.text
        
        object.saveInBackgroundWithBlock { (succeed, Error) -> Void in
            if (succeed == true) {
                self.remove()
//                let nav = self.selectedViewController as! UINavigationController
//                if ((nav.viewControllers[0].isKindOfClass(TableViewController)) == true){
//                    print("true")
//                    let tab = nav.viewControllers[0] as! TableViewController
//                }
            } else {
                print (Error!.userInfo["error"])
            }
        }
    }
    
    func remove() {
        self.tabBar.userInteractionEnabled = true
        test =  self.view.subviews[self.view.subviews.count - 1]
        test.layer.removeAllAnimations()
        let animate = CABasicAnimation(keyPath: "position.y")
        animate.fromValue = self.view.center.y
        animate.toValue = 800
        animate.delegate = self
        let fading = CABasicAnimation(keyPath: "opacity")
        fading.duration = 0.6
        fading.fromValue = 1
        fading.toValue = 0
        fading.fillMode = kCAFillModeForwards
        fading.removedOnCompletion = false
        test.layer.addAnimation(animate, forKey: "ciao")
        test.layer.addAnimation(fading, forKey: "alpha")
        test.layer.position = CGPointMake(self.view.center.x, 800)
        spin.removeFromSuperview()
    }
    
    override func animationDidStart(anim: CAAnimation) {
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if (test != nil) {
            test.removeFromSuperview()}
        if (keep != nil) {
            keep.removeFromSuperview()}
        self.selectedViewController?.reloadInputViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

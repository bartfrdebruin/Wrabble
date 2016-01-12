//
//  AppDelegate.swift
//  Wrabble
//
//  Created by Bart de Bruin on 07-01-16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Keys.plist with applicationID and clientID of Parse.
        var loginDictionary: NSDictionary!
        let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist")
        loginDictionary = NSDictionary(contentsOfFile: path!)
        
        let applicationId = (loginDictionary!["parseApplicationId"] as! String)
        let clientKey = (loginDictionary!["parseClientKey"] as! String)
        
        // Parse Initialization.
        Parse.setApplicationId(applicationId, clientKey: clientKey)
        
        
        
        if (PFUser.currentUser() != nil) {
            startTab()
        } else {
            let tabbar = UITabBarController()
            setNav(tabbar)
        }
        return true
    }
    
    func setNav(nav : UITabBarController){
        let login = LoginViewController()
        nav.tabBar.hidden = true
        nav.viewControllers = [login]
        self.window!.rootViewController = nav
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
        self.window!.rootViewController = tabbar
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


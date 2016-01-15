//
//  UserViewController.swift
//  Wrabble
//
//  Created by Eyolph on 11/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import AVFoundation
class UserViewController: TableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var headerView : UIView!
    var user : PFUser!
    var menu : UIView!
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: .Plain, className: "Wrabbles")
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        user = PFUser.currentUser()
        user.fetchInBackground()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Wrabbles")
        query.whereKey("userID", containsString: PFUser.currentUser()?.objectId)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.headerView = NSBundle.mainBundle().loadNibNamed("Header", owner: self, options: nil).first as! UIView
        headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 120);
        setHeader()
        return headerView
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        cell.titleLabel?.text = object!["name"] as? String
        cell.userLabel?.text = nil
        cell.play.tag = indexPath.row
        cell.play.addTarget(self, action: "playRecord:", forControlEvents: .TouchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     func setHeader() {
        let wrabbles = headerView.viewWithTag(1) as! UILabel
        wrabbles.text = "\(objects!.count) Wrabbles"
        let followers = headerView.viewWithTag(2) as! UIButton
        followers.addTarget(self, action: "pushFollowers", forControlEvents: .TouchUpInside)
        let following = headerView.viewWithTag(3) as! UIButton
        following.addTarget(self, action: "pushFollowing", forControlEvents: .TouchUpInside)
        let changePic = headerView.viewWithTag(4) as! UIButton
        let menu = headerView.viewWithTag(7) as! UIButton
        menu.addTarget(self, action: "showsMenu", forControlEvents: .TouchUpInside)
        menu.userInteractionEnabled = true
        changePic.addTarget(self, action: "changePic", forControlEvents: .TouchUpInside)
        let userPic = headerView.viewWithTag(5) as! PFImageView
        let file = self.user["image"] as? PFFile
        file?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if (error == nil) {
                let image = UIImage(data: data!)
                userPic.image = image
            }
        })
        let userLabel = headerView.viewWithTag(6) as! UILabel
        userLabel.text = self.user.username
    }
    
    func pushFollowers() {
        let follower = CollectionViewController()
        self.navigationController?.pushViewController(follower, animated: true)
    }
    
    func pushFollowing() {
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            if (error == nil){
                let following = LoginViewController()
                self.navigationController?.pushViewController(following, animated: true)
            }
        }
//        let following = CollectionViewController()
//        self.navigationController?.pushViewController(following, animated: true)
    }
    
    func showsMenu() {
     
        menu = NSBundle.mainBundle().loadNibNamed("MenuView", owner: self, options: nil).last as! UIView
        menu.frame = CGRectMake(0, 0, menu.frame.size.width, self.view.frame.size.height)
        headerView.addSubview(menu)
        self.tableView.scrollEnabled = false
        self.tabBarController?.tabBar.userInteractionEnabled = false
        menu.userInteractionEnabled = true
        let anim = CABasicAnimation(keyPath: "position.x")
        anim.fromValue = 0-menu.frame.size.width
        anim.toValue =  menu.frame.size.width/2
        anim.duration = 0.6
        anim.removedOnCompletion = true
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        menu.layer.addAnimation(anim, forKey: "show")
        menu.layer.position = CGPointMake(menu.frame.size.width/2, self.view.center.y)
        let back = menu.viewWithTag(1) as! UIButton
        back.addTarget(self, action: "closeMenu:", forControlEvents: .TouchUpInside)
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = (M_PI*2)
        rotate.duration = 0.6
        rotate.repeatCount = 1
        rotate.removedOnCompletion = true
        back.layer.addAnimation(rotate, forKey: "rotation")
    }
    
    func closeMenu(sender : UIButton) {
        self.tableView.scrollEnabled = true
        self.tabBarController?.tabBar.userInteractionEnabled = true
        let exit = CABasicAnimation(keyPath: "position.x")
        exit.fromValue = menu.frame.size.width/2
        exit.toValue = 0-menu.frame.size.width
        exit.duration = 0.6
        exit.delegate = self
        exit.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        menu.layer.addAnimation(exit, forKey: "hide")
        menu.layer.position = CGPointMake(0-menu.frame.size.width, self.view.center.y)
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = -(M_PI*2)
        rotate.duration = 0.6
        rotate.repeatCount = 1
        rotate.removedOnCompletion = true
        sender.layer.addAnimation(rotate, forKey: "rotation")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        menu.removeFromSuperview()
    }
    
    func changePic(){
        let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.allowsEditing = true
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let userPic = headerView.viewWithTag(5) as! PFImageView
        let user = PFUser.currentUser()
        let data = UIImageJPEGRepresentation(image, 0.5)
        let file = PFFile(data: data!)
        user?.setObject(file!, forKey: "image")
        user?.saveInBackgroundWithBlock({ (succeed, error) -> Void in
             userPic.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}

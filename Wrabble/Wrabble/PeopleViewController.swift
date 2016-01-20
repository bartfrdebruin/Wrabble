//
//  PeopleViewController.swift
//  Wrabble
//
//  Created by Eyolph on 15/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AVFoundation

class PeopleViewController: UserViewController {

    var userPeople : PFObject!
    
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: .Plain, className: "Wrabbles")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     override func queryForTable() -> PFQuery {
        super.queryForTable()
        let query = PFQuery(className: "Wrabbles")
        query.whereKey("userID", containsString: userPeople.objectId)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
    }
    
    override func setHeader() {
        let wrabbles = headerView.viewWithTag(1) as! UILabel
        wrabbles.text = "\(objects!.count) Wrabbles"
        let followersButton = headerView.viewWithTag(2) as! UIButton
        let query = PFQuery(className: "followers")
        query.whereKey("userID", equalTo: (userPeople.objectId)!)
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            self.followOb = object
            self.followers = object!["followers"] as! Array<String>
            followersButton.setTitle("\(self.followers.count) Followers", forState: .Normal)
            followersButton.addTarget(self, action: "pushFollowers", forControlEvents: .TouchUpInside)
            let followingButton = self.headerView.viewWithTag(3) as! UIButton
            self.following = object!["following"] as! Array<String>
            followingButton.setTitle("\(self.following.count) Following", forState: .Normal)
            followingButton.addTarget(self, action: "pushFollowing", forControlEvents: .TouchUpInside)
            let changePic = self.headerView.viewWithTag(4) as! UIButton
            changePic.setTitle("Follow", forState: .Normal)
            changePic.addTarget(self, action: "follow:", forControlEvents: .TouchUpInside)
        }

        let menu = headerView.viewWithTag(7) as! UIButton
        menu.userInteractionEnabled = true
        menu.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        let userPic = headerView.viewWithTag(5) as! PFImageView
        userPic.file = nil
        let file = self.userPeople["image"] as? PFFile
        userPic.file = file
        userPic.loadInBackground()
        headerView.reloadInputViews()
        headerView.setNeedsDisplay()
        let userLabel = headerView.viewWithTag(6) as! UILabel
        userLabel.text = self.userPeople["username"] as? String
    }
    
    func follow(sender : UIButton) {
        var followers = followOb["followers"] as? Array<String>
        followers?.append((PFUser.currentUser()?.objectId)!)
        followOb!["followers"] = followers
        followOb.saveInBackground()
        
        let query = PFQuery(className: "followers")
        query.whereKey("userID", equalTo: PFUser.currentUser()!.objectId!)
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            var following = object!["following"] as? Array<String>
            following!.append(self.userPeople.objectId!)
            object!["following"] = following
            object!.saveInBackgroundWithBlock { (done, error) -> Void in
                sender.enabled = false
            }
            self.setHeader()
        }
      
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func pushFollowers() {
        let follower = CollectionViewController()
        follower.array = self.followers
        self.navigationController?.pushViewController(follower, animated: true)
    }
    
    override func pushFollowing() {
        let following = FollowersVC()
        following.array = self.following
        self.navigationController?.pushViewController(following, animated: true)
    }
    
    
    
    
    
}

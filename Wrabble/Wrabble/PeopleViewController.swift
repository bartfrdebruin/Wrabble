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
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        self.headerView = NSBundle.mainBundle().loadNibNamed("Header", owner: self, options: nil).first as! UIView
//        headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 120);
//        setHeader()
//        return headerView
//    }
    
    override func setHeader() {
        let wrabbles = headerView.viewWithTag(1) as! UILabel
        wrabbles.text = "\(objects!.count) Wrabbles"
        let followers = headerView.viewWithTag(2) as! UIButton
        let followersArray = userPeople["followers"] as! Array<String>
        followers.setTitle("\(followersArray.count) Followers", forState: .Normal)
        followers.addTarget(self, action: "pushFollowers", forControlEvents: .TouchUpInside)
        let following = headerView.viewWithTag(3) as! UIButton
        let followingArray = userPeople["followers"] as! Array<String>
        following.setTitle("\(followingArray.count) Following", forState: .Normal)
        following.addTarget(self, action: "pushFollowing", forControlEvents: .TouchUpInside)
        let changePic = headerView.viewWithTag(4) as! UIButton
        changePic.removeFromSuperview()
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
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

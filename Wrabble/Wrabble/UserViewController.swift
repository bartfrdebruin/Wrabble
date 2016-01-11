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

class UserViewController: PFQueryTableViewController, UINavigationControllerDelegate {

    var headerView : UIView!
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: .Grouped, className: "Wrabbles")
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Wrabbles")
        query.whereKey("userID", containsString: PFUser.currentUser()?.objectId)
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
        setToolbar()
    }
    
    func setToolbar() {
        let button = UIBarButtonItem(title: "ciao", style: .Plain, target: self, action: "ciao")
        self.toolbarItems = [button]
        self.navigationController?.toolbarHidden = false
    }
    
     func setHeader() {
        let wrabbles = headerView.viewWithTag(1) as! UILabel
        wrabbles.text = "\(objects!.count) Wrabbles"
    }
    

}

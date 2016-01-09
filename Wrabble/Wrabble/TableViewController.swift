//
//  TableViewController.swift
//  Wrabble
//
//  Created by Eyolph on 09/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import AVFoundation

class TableViewController: PFQueryTableViewController, AVAudioPlayerDelegate {
    
    var player : AVAudioPlayer!
    var circular : KYCircularProgress!

    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: .Grouped, className: "Wrabbles")
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Wrabbles")
        return query
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        cell.titleLabel?.text = object!["name"] as? String
        cell.userLabel?.text = object!["username"] as? String
        cell.play.tag = indexPath.row
        cell.play.addTarget(self, action: "playRecord:", forControlEvents: .TouchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    func playRecord(sender : UIButton) {
        let ob = objects![sender.tag] as! PFObject
        let file = ob["rec"] as! PFFile
        file.getFilePathInBackgroundWithBlock { (string, error) -> Void in
            let url = NSURL(fileURLWithPath: string!)
            do {
                self.player = try AVAudioPlayer(contentsOfURL: url)
                self.player.delegate = self
                self.player.prepareToPlay()
                self.player.volume = 1.0
                self.player.play()
                let indexPath = NSIndexPath(forRow: sender.tag, inSection: 1)
                self.progressCircular(indexPath)
            } catch let error as NSError {
                self.player = nil
                print(error.localizedDescription)
            }
        }
        }
    
    
    func progressCircular(indexPath : NSIndexPath) {
        circular = KYCircularProgress(frame: CGRectMake(0, 0, 50, 50))
        
        let cell = tableView.visibleCells[indexPath.row] as! TableViewCell
        
        cell.play.hidden = true
        circular.center = cell.play.center
        
        
        cell.contentView.addSubview(circular)
        circular.colors = [UIColor(rgba: 0xA6E39D11), UIColor(rgba: 0xAEC1E355), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABFF)]
        circular.lineWidth = 5
        let displayLink = CADisplayLink(target: self, selector: ("updateProgress"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func updateProgress() {
        circular.progress = player.currentTime/player.duration
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        for cell in tableView.visibleCells as! [TableViewCell] {
            cell.play.hidden = false
            circular.removeFromSuperview()
        }
        
            }
}

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
    var pauseTime : NSTimeInterval!
    var tagPlaying : Int?
    
    
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
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
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
        if (player != nil && player.playing == true){
            self.afterPlay()
        }
        let ob = objects![sender.tag] as! PFObject
        let file = ob["rec"] as! PFFile
        file.getFilePathInBackgroundWithBlock { (string, error) -> Void in
            let url = NSURL(fileURLWithPath: string!)
            do {
                self.player = try AVAudioPlayer(contentsOfURL: url)
                self.player.delegate = self
                self.player.prepareToPlay()
                self.player.volume = 1.0
                // IF IS PLAYING THE SAME FILE AFTER PAUSE
                if (self.player.playing == false && self.pauseTime != nil && self.tagPlaying == sender.tag) {
                    self.player.prepareToPlay()
                    self.player.currentTime = self.pauseTime
                    self.player.play()
                    self.pauseTime = nil
                    print("SAME FILE AFTER PAUSE")
                    // IS ANOTHER FILE
                } else if (self.player.playing == false && self.tagPlaying != sender.tag)  {
                    self.player.play()
                    self.afterPlay()
                    print("ANOTHER FILE")
                }
                let indexPath = NSIndexPath(forRow: sender.tag, inSection: 1)
                if (self.circular != nil) {
                    self.circular.removeFromSuperview()}
                self.progressCircular(indexPath)
                self.playing(indexPath)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func playing(indexPath : NSIndexPath) {
        
        let cell = tableView.visibleCells[indexPath.row] as! TableViewCell
        if (cell.detailView.hidden == true) {
            
        } else {
            cell.detailView.hidden = true
            cell.playingView.hidden = false
        }
        let min = Int(player.duration / 60)
        let sec = Int(player.duration % 60)
        let s = String(format: "%02d:%02d", min, sec)
        cell.timeLabel.text = s
        cell.slider.tag = indexPath.row
        cell.slider.addTarget(self, action: "slide:", forControlEvents: UIControlEvents.TouchUpInside)
        let displayLink = CADisplayLink(target: self, selector: ("setSlider"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func setSlider() {
        for cell in tableView.visibleCells as! [TableViewCell] {
            cell.slider.maximumValue = Float(player.duration)
            cell.slider.setValue(Float(player.currentTime), animated: true)
        }
    }
    
    func slide(sender : UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 1)
        let cell = tableView.visibleCells[indexPath.row] as! TableViewCell
        player.currentTime = Double(cell.slider.value)
    }
    
    
    func progressCircular(indexPath : NSIndexPath) {
        circular = KYCircularProgress(frame: CGRectMake(0, 0, 50, 50))
        
        let cell = tableView.visibleCells[indexPath.row] as! TableViewCell
        
        cell.play.setTitle("||", forState: .Normal)
        cell.play.removeTarget(self, action: "playRecord:", forControlEvents: .TouchUpInside)
        cell.play.addTarget(self, action: "stop:", forControlEvents: .TouchUpInside)
        circular.center = cell.play.center
        
        cell.miniView.addSubview(circular)
        circular.colors = [UIColor(rgba: 0xA6E39D11), UIColor(rgba: 0xAEC1E355), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABFF)]
        circular.lineWidth = 5
        
        circular.progress = 0
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "updateInfinity", userInfo: nil, repeats: true)
        //        let displayLink = CADisplayLink(target: self, selector: ("updateProgress"))
        //        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func stop(sender : UIButton) {
        player.pause()
        pauseTime = player.currentTime
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 1)
        let cell = tableView.visibleCells[indexPath.row] as! TableViewCell
        tagPlaying = sender.tag
        cell.play.setTitle("Play", forState: .Normal)
        cell.play.removeTarget(self, action: "stop:", forControlEvents: .TouchUpInside)
        cell.play.addTarget(self, action: "playRecord:", forControlEvents: .TouchUpInside)
    }
    
    
    func updateProgress() {
        circular.progress = player.currentTime/player.duration
    }
    
    func updateInfinity()
    {
        circular.progress += 0.01
        let white = KYCircularProgress(frame: circular.frame)
        white.progressGuideColor = UIColor.whiteColor()
        circular.progress += 0.05
        self.view.addSubview(white)
        if (circular.progress > 0.99){
            circular.progress = 0
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        afterPlay()
    }
    
    func afterPlay () {
        for cell in tableView.visibleCells as! [TableViewCell] {
            cell.detailView.hidden = false
            cell.playingView.hidden = true
            cell.play.setTitle("Play", forState: .Normal)
            cell.play.removeTarget(self, action: "stop:", forControlEvents: .TouchUpInside)
            cell.play.addTarget(self, action: "playRecord:", forControlEvents: .TouchUpInside)
            if (circular != nil) {
                circular.removeFromSuperview()
            }
        }
    }
}

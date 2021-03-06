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
    var pauseTime : NSTimeInterval!
    var tagPlaying : Int?
    var cellSelected : TableViewCell!
    var tagPlay : Int?
    //to get oscilation for animation class
    var meteringEnabled: Bool!
    var averagePowerForChannel: CFloat!
    var peakPeakPowerChannel: CFloat!

    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: .Plain, className: "Wrabbles")
 
//        tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.meteringEnabled = true
        //player.unpdateMeters()
        let frame = CGRectMake(self.view.center.x - 25, self.view.frame.size.height - 100, 50, 50)
        let butt = UIButton(frame:frame)
        let image = UIImage(named: "spinning")
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        butt.setImage(image, forState: .Normal)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? TableViewCell
        if indexPath.row == tagPlay{
            cell?.playingView.hidden = false
            cell?.detailView.hidden = true
        }
        cell!.playingView.hidden = true
        cell!.titleLabel?.text = object!["name"] as? String
        cell!.userLabel?.text = object!["username"] as? String
        cell!.play.tag = indexPath.row
        cell!.play.addTarget(self, action: "playRecord:", forControlEvents: .TouchUpInside)
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        cell!.add.tag = indexPath.row
        cell!.add.addTarget(self, action: "addMash:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    func playRecord(sender : UIButton) {

        tagPlay = sender.tag
        setSessionPlayback()
        if (player != nil && player.playing == true){
            self.afterPlay(cellSelected)
        }
        let ob = objects![sender.tag] as! PFObject
        let file = ob["rec"] as! PFFile
        file.getDataInBackgroundWithBlock { (data, error) -> Void in

            do {
                self.player = try AVAudioPlayer(data: data!, fileTypeHint: "m4a")
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
                    if (self.cellSelected != nil){
                    self.afterPlay(self.cellSelected)
                    }
                    self.cellSelected = sender.superview?.superview as! TableViewCell
                    
                    self.player.play()
                    print("ANOTHER FILE")
                }
                    self.playing()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func addMash (sender : UIButton) {
        let ob = objects![sender.tag] as! PFObject
        var arr = PFUser.currentUser()!["mash"] as! Array<String>
        arr.append(ob.objectId!)
        PFUser.currentUser()!.setObject(arr, forKey: "mash")
        PFUser.currentUser()!.saveInBackground()
    }

    
    func playing() {
        if (cellSelected.detailView.hidden == true) {
        } else {
            cellSelected.detailView.hidden = true
            cellSelected.playingView.hidden = false
        }
        cellSelected.play.setTitle("||", forState: .Normal)
        cellSelected.play.removeTarget(self, action: "playRecord:", forControlEvents: .TouchUpInside)
        cellSelected.play.addTarget(self, action: "stop:", forControlEvents: .TouchUpInside)
        let min = Int(player.duration / 60)
        let sec = Int(player.duration % 60)
        let s = String(format: "%02d:%02d", min, sec)
        cellSelected.timeLabel.text = s
        cellSelected.slider.addTarget(self, action: "slide", forControlEvents: UIControlEvents.TouchUpInside)
        let displayLink = CADisplayLink(target: self, selector: ("setSlider"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func setSlider() {
            cellSelected.slider.maximumValue = Float(player.duration)
            cellSelected.slider.setValue(Float(player.currentTime), animated: true)
    }
    
    func slide() {
        player.currentTime = Double(cellSelected.slider.value)
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print(error.localizedDescription)
            print("setCategory")
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("sessionActive")
            print(error.localizedDescription)
        }
    }

    func stop(sender : UIButton) {
        player.pause()
        pauseTime = player.currentTime
        cellSelected.play.setTitle("Play", forState: .Normal)
        cellSelected.play.removeTarget(self, action: "stop:", forControlEvents: .TouchUpInside)
        tagPlaying = sender.tag
        cellSelected.play.addTarget(self, action: "playRecord:", forControlEvents: .TouchUpInside)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        afterPlay(cellSelected)
        tagPlay = nil
    }

    func afterPlay (cell : TableViewCell) {
            cell.detailView.hidden = false
            cell.playingView.hidden = true
            cell.play.setTitle("Play", forState: .Normal)
            cell.play.removeTarget(self, action: "stop:", forControlEvents: .TouchUpInside)
            cell.play.addTarget(self, action: "playRecord:", forControlEvents: .TouchUpInside)
    }

    func unpdateMeters() {
    var channels: Int = self.player.numberOfChannels
    
}

    func timerFunc(timer:NSTimer!) {

}
}

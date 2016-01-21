//
//  MashViewController.swift
//  Wrabble
//
//  Created by Eyolph on 20/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class MashViewController: TableViewController {
    
    var mashes : Array<String>!
    var footerView : UIView!
    var array : Array<NSURL>!
    var compilation : AVMutableComposition!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Wrabbles")
        query.whereKey("objectId", containedIn: mashes)
        array = []
        return query
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView = NSBundle.mainBundle().loadNibNamed("Header", owner: self, options: nil).first as! UIView
        footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 120);
        setFooter()
        return footerView
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120
    }

    
    func setFooter() {
      
        let button = footerView.viewWithTag(4) as! UIButton
        button.setTitle("mash", forState: .Normal)
        button.addTarget(self, action: "doMash", forControlEvents: .TouchUpInside)
    }
    
    
    
    func doMash(){
        let file = objects![0]["rec"] as! PFFile
        let url = NSURL(string: file.url!)
//            "\(file.url!).M4a")
        self.array.append(url!)
        let file2 = objects![1]["rec"] as! PFFile
        let url2 = NSURL(string: file2.url!)
        self.array.append(url2!)
        do {
            self.player = try AVAudioPlayer(contentsOfURL: url!)
            self.player.delegate = self
            self.player.prepareToPlay()
            self.player.volume = 1.0
    } catch let error as NSError {
        print(error.localizedDescription)

    }
    }
        
    
    
    
    func mash() {
    
        }
    
//    var documentsDirectory:String = paths[0] as! String
    
    //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
//    compilation = AVMutableComposition()
//    let compositionAudioTrack1:AVMutableCompositionTrack = compilation.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
//    let compositionAudioTrack2:AVMutableCompositionTrack = compilation.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
//    
//    //create new file to receive data
//    let documentDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
//    let fileDestinationUrl = documentDirectory.URLByAppendingPathComponent("resultmerge.M4a")
//    print(fileDestinationUrl)
//    
//    let avAsset1 = AVAsset(URL: array[0])
//    let avAsset2 = AVURLAsset(URL: array[1], options: nil)
//
//    let assetTrack1:AVAssetTrack = avAsset1.tracksWithMediaType(AVMediaTypeAudio).first!
//    let assetTrack2:AVAssetTrack = avAsset2.tracksWithMediaType(AVMediaTypeAudio).first!
//    
//    
//    let duration1: CMTime = assetTrack1.timeRange.duration
//    let duration2: CMTime = assetTrack2.timeRange.duration
//    
//    let timeRange1 = CMTimeRangeMake(kCMTimeZero, duration1)
//    let timeRange2 = CMTimeRangeMake(duration1, duration2)
//    
//        do { try compositionAudioTrack1.insertTimeRange(timeRange1, ofTrack: assetTrack1, atTime: kCMTimeZero)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//    
//        do { try compositionAudioTrack2.insertTimeRange(timeRange2, ofTrack: assetTrack2, atTime: duration1)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
    
    //AVAssetExportPresetPassthrough => concatenation
//        let assetExport = AVAssetExportSession(asset: compilation, presetName: AVAssetExportPresetAppleM4A)
//        assetExport!.outputFileType = AVFileTypeAppleM4A
////    assetExport!.outputURL = fileDestinationUrl
//    assetExport!.exportAsynchronouslyWithCompletionHandler({
//    switch assetExport!.status{
//    case  AVAssetExportSessionStatus.Failed:
//    print("failed \(assetExport!.error)")
//    case AVAssetExportSessionStatus.Cancelled:
//    print("cancelled \(assetExport!.error)")
//    default:
//    print("complete")
//    var audioPlayer = AVAudioPlayer()
////    do {
////        try audioPlayer = AVAudioPlayer(contentsOfURL: fileDestinationUrl, fileTypeHint: AVFileTypeAppleM4A)
////    } catch let error as NSError {
////        print(error.localizedDescription)
////    }
////    audioPlayer.prepareToPlay()
////    audioPlayer.play()
//    let data = NSData(contentsOfURL: fileDestinationUrl)

//    let file = PFFile(name: "file.m4a", data: data!)
//    let object = PFObject(className: "Wrabbles")
//    object["rec"] = file
//    object["userID"] = PFUser.currentUser()?.objectId
//    object["username"] = PFUser.currentUser()?.username
//    object["name"] = "test"
//    
//    object.saveInBackgroundWithBlock { (succeed, Error) -> Void in
//        if (succeed == true) {
//            print("done")
//        } else {
//            
//            print (Error!.userInfo["error"])
//        }
//    }
//    })
        
    
    
    override func setSessionPlayback() {
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
}


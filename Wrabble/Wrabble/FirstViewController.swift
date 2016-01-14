//
//  FirstViewController.swift
//  Wrabble
//
//  Created by Bart de Bruin on 07-01-16.
//  Copyright © 2016 Wrabble. All rights reserved.

import UIKit
import AVFoundation
import Parse


 class FirstViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate {
    
    var recorder: AVAudioRecorder!
    
    var player:AVAudioPlayer!
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var circular : KYCircularProgress!
    var fileName : String!
    var meterTimer:NSTimer!
    var soundFileURL:NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.enabled = false
        playButton.enabled = false
        setSessionPlayback()
        checkHeadphones()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
//        super.view.subviews.last?.removeFromSuperview()
    }
    
    func updateAudioMeter(timer:NSTimer) {
        if recorder.recording {
            let min = Int(recorder.currentTime / 60)
            let sec = Int(recorder.currentTime % 60)
            let s = String(format: "%02d:%02d", min, sec)
            statusLabel.text = s
            recorder.updateMeters()
        }
    }
    
    @IBAction func save(sender: UIButton) {
        let test = TestViewController()
        self.view.addSubview(test.view)
        let animate = CABasicAnimation(keyPath: "position.y")
        animate.fromValue = 800
        animate.toValue = self.view.center.y
        test.view.layer.addAnimation(animate, forKey: "ciao")
        let backButton = test.view.viewWithTag(1) as! UIButton
        backButton.addTarget(self, action: "remove", forControlEvents: .TouchUpInside)
        let saveBn = test.view.viewWithTag(2) as! UIButton
        saveBn.addTarget(self, action: "saveRecord", forControlEvents: .TouchUpInside)
        let field = test.view.viewWithTag(3) as! UITextField
        field.placeholder = fileName
    }
    
    @IBAction func record(sender: UIButton) {
        
        if player != nil && player.playing {
            player.stop()
        }
        if recorder == nil {
            recordButton.setTitle("Pause", forState:.Normal)
            playButton.enabled = false
            stopButton.enabled = true
            recordWithPermission(true)
            return
        }
        if recorder != nil && recorder.recording {
            recorder.pause()
            recordButton.setTitle("Continue", forState:.Normal)
            
        } else {
            recordButton.setTitle("Pause", forState:.Normal)
            playButton.enabled = false
            stopButton.enabled = true
            recordWithPermission(false)
        }
    }
    
    @IBAction func stop(sender: UIButton) {
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
        recordButton.setTitle("Record", forState:.Normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            playButton.enabled = true
            stopButton.enabled = false
            recordButton.enabled = true
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func play(sender: UIButton) {
//        setSessionPlayback()
//        play()
        let circ = SpinLoading(frame: CGRectMake(0, 0, 100, 100))
        circ.center = self.view.center
        self.view.addSubview(circ)
        circ.animate(120)
    }
    
    
    func remove() {
        let test =  self.view.subviews[self.view.subviews.count - 1]
        test.layer.removeAllAnimations()
        let animate = CABasicAnimation(keyPath: "position.y")
        animate.fromValue = self.view.center.y
        animate.toValue = 800
        animate.delegate = self
        let fading = CABasicAnimation(keyPath: "opacity")
        fading.duration = 0.2
        fading.fromValue = 1
        fading.toValue = 0
        fading.fillMode = kCAFillModeForwards
        fading.removedOnCompletion = false
        test.layer.addAnimation(animate, forKey: "ciao")
        test.layer.addAnimation(fading, forKey: "alpha")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
         self.view.subviews[self.view.subviews.count - 1].removeFromSuperview()
    }
    
    func saveRecord(){
        let data = NSData(contentsOfURL: self.recorder.url)
        let name = self.view.subviews[self.view.subviews.count - 1].viewWithTag(3) as! UITextField
        name.userInteractionEnabled = true
        let file = PFFile(name: name.text, data: data!)
        let object = PFObject(className: "Wrabbles")
        object["rec"] = file
        object["userID"] = PFUser.currentUser()?.objectId
        object["username"] = PFUser.currentUser()?.username
        object["name"] = name.text
        
        object.saveInBackgroundWithBlock { (succeed, Error) -> Void in
            if (succeed == true) {
            self.remove()
            } else {
                print (Error!.userInfo["error"])
        }
        }
    }
    
    func play() {
        
        var url:NSURL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        
        do {
            self.player = try AVAudioPlayer(contentsOfURL: url!)
            stopButton.enabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
            progressCircular()
            
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }
        
    }
    
    
    func setupRecorder() {
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        fileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        self.soundFileURL = documentsDirectory.URLByAppendingPathComponent(fileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        
        do {
            recorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.meteringEnabled = true
            recorder.prepareToRecord()
            // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func recordWithPermission(setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        if (session.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.recordForDuration(5.0)
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                        target:self,
                        selector:"updateAudioMeter:",
                        userInfo:nil,
                        repeats:true)
                } else {
                }
            })
        } else {
        }
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    func checkHeadphones() {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        }
    }
    
        
    func progressCircular() {
        circular = KYCircularProgress(frame: CGRectMake(0, 0, 100, 100))
        circular.center = CGPointMake(self.view.center.x, self.view.center.y - 50)
        

        self.view.addSubview(circular)
        circular.colors = [UIColor(rgba: 0xA6E39D11), UIColor(rgba: 0xAEC1E355), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABFF)]
        circular.lineWidth = 5
        let displayLink = CADisplayLink(target: self, selector: ("updateProgress"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func updateProgress() {
        circular.progress = player.currentTime/player.duration

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder,
        successfully flag: Bool) {
            stopButton.enabled = false
            playButton.enabled = true
            recordButton.setTitle("Record", forState:.Normal)
    }


    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.enabled = true
        stopButton.enabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}

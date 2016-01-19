//
//  Recorder.swift
//  Wrabble
//
//  Created by Eyolph on 14/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import AVFoundation

class Recorder: NSObject, AVAudioRecorderDelegate {
    
    var recorder: AVAudioRecorder!
    var fileName : String!
    var meterTimer:NSTimer!
    var soundFileURL:NSURL!
    
    
    func updateAudioMeter(timer:NSTimer) {
        if recorder.recording {
            recorder.updateMeters()
        }
    }
    
    
     func record() {
        
        if recorder == nil {
            recordWithPermission(true)
            return
        }
        if recorder != nil && recorder.recording {
            recorder.pause()
            
        } else {
            recordWithPermission(false)
        }
    }
    
     func stop() {
        
        recorder?.stop()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    func setupRecorder() {
        setSessionPlayback()
       let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        fileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        self.soundFileURL = documentsDirectory.URLByAppendingPathComponent(fileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(soundFileURL.absoluteString) {
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
}

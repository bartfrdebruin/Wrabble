//
//  FirstViewController.swift
//  Wrabble
//
//  Created by Bart de Bruin on 07-01-16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation



class FirstViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    var recorder : AVAudioRecorder
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.recorder = AVAudioRecorder()
        super.init(nibName: "FirstViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func record(sender: UIButton) {
        recorder.recordForDuration(5.0)
        
    }

    @IBAction func play(sender: UIButton) {
    }
}


//
//  TableViewCell.swift
//  Wrabble
//
//  Created by Eyolph on 09/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AVFoundation

class TableViewCell: PFTableViewCell, AVAudioPlayerDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playingView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var miniView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var play: UIButton!
    var url : NSURL?


    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "slide")
        slider.setThumbImage(image, forState:.Normal)
        slider.setThumbImage(image, forState:.Selected)

    }

    
}

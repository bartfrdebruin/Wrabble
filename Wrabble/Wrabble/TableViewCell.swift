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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var play: UIButton!
    var url : NSURL?


    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    
}

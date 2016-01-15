//
//  CollectionViewCell.swift
//  Wrabble
//
//  Created by Eyolph on 14/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: PFImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

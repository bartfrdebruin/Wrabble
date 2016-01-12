//
//  SpinLoading.swift
//  Wrabble
//
//  Created by Eyolph on 12/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit

class SpinLoading: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "spinning")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(speed : Float) {
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fillMode = kCAFillModeForwards;
        rotate.fromValue = 0
        rotate.toValue = (M_PI*2)
        rotate.duration = 50
        rotate.speed = speed
        rotate.repeatCount = 5
        self.layer.addAnimation(rotate, forKey: "rotation")
    }
}

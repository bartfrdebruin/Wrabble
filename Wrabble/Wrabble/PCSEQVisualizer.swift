//
//  PCSEQVisualizer.swift
//  
//
//  Created by Marina Huber on 1/20/16.
//
//

import UIKit

struct bars {
    
   static let kWidth = 1
   static let kHeight = 50
   static let kPadding = 50


class PCSEQVisualizer: UIView {

    var numberOfBars : Int!
    var timer: NSTimer!
    var barArray: NSArray!
    
    init (initWithNumberOfBars bars : Int) {
    super.init(frame: CGRectMake(0, 0, CGFloat(kWidth * bars), CGFloat(kHeight)))
        self.numberOfBars = bars
         var tempBarArray = Array<UIImage>()
        
        
        for i in 0..<numberOfBars {
            
            let bar: UIImage = UIImage (named:"second")!
            let barView = UIImageView(image: bar)
            barView.frame = CGRectMake(CGFloat(i*kWidth+i*kPadding), 0, CGFloat(kWidth), 1)
            self.addSubview(barView)
            tempBarArray.append(bar)

        }

        let transform: CGAffineTransform = CGAffineTransformMakeRotation(CGFloat(M_PI*2))
        self.transform = transform
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stop", name: "stopTimer", object: nil)
        
    }
    
   

    func start() {
        self.hidden = false
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: "ticker", userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func ticker() {
        UIView.animateWithDuration(0.35, animations: {() -> Void in
            for bar: UIImageView in self.barArray as! [UIImageView] {
                var rect: CGRect = bar.frame
                rect.size.height = self.random(min: 0, max: CGFloat(kHeight))
                bar.frame = rect
            }
        })}
}
}




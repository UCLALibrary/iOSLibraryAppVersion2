//
//  dayOfWeekAndHoursBox.swift
//  UCLA Library
//
//  Created by Regan Hsu on 3/20/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit

class dayOfWeekAndHoursBox: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.customInit("50", open: "88", close: "50");
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.customInit("50", open: "40", close: "50");
    }
    
    func customInit(day:String, open:String, close:String) {
//        self.layer.cornerRadius = 10;
//        self.layer.shadowColor = UIColor(white: 0, alpha: 1).CGColor;
//        self.layer.shadowOffset = CGSizeMake(2, 2);
//        self.layer.shadowOpacity = 0.5;
//        self.layer.shadowRadius = 3;
        self.layer.backgroundColor = UIColor.blueColor().CGColor
        var label = UILabel(frame: CGRectMake(0, 0, 50, 50))
        label.center = CGPointMake(25, 25)
        label.textAlignment = NSTextAlignment.Center
        label.text = open
        label.backgroundColor = UIColor.yellowColor()
        self.addSubview(label)
    
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

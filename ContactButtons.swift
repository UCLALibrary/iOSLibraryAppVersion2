//
//  ContactButtons.swift
//  UCLA Library
//
//  Created by Regan Hsu on 4/20/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit

class ContactButtons: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 20.0
        clipsToBounds = true
        setBackgroundColor(UIColor.yellowColor(), forState: .Highlighted)
        setBackgroundColor(UIColor.yellowColor(), forState: .Focused)
        setBackgroundColor(UIColor.yellowColor(), forState: .Selected)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, forState: forState)
    }

}

//
//  MenuButtons.swift
//  UCLA Library
//
//  Created by Regan Hsu on 4/16/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit

class MenuButtons: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.whiteColor().CGColor//tintColor.CGColor
        layer.cornerRadius = 20.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        
        
        //setBackgroundImage(UIImage(contentsOfFile: tintColor), forState: .Highlighted)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

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
        layer.borderColor = UIColor.white.cgColor//tintColor.CGColor
        layer.cornerRadius = 30.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 15, left: 8, bottom: 15, right: 8)

        setTitleColor(UIColor.init(red: 27/255, green: 143/255, blue: 232/255, alpha: 1), for: UIControlState())

        setTitleColor(UIColor.white, for: .highlighted)
        
        setBackgroundColor(UIColor.white, forState: UIControlState())

        
        
        //setBackgroundImage(UIImage(contentsOfFile: tintColor), forState: .Highlighted)
    }

    func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

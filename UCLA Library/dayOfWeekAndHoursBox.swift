//
//  dayOfWeekAndHoursBox.swift
//  UCLA Library
//
//  Created by Regan Hsu on 3/20/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit

class dayOfWeekAndHoursBox: UIView {
    
    init(frame: CGRect, dayOfweek:String, open:String, close:String, dayOfMonth:Int) {
        super.init(frame: frame);
        self.customInit(dayOfweek, open: open, close: close, dayInMonth: dayOfMonth);
    }
    
    
    //probably not needed but Stack Overflow said it was
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.customInit("-", open: "-", close: "-", dayInMonth: 0);
    }
    
    func customInit(day:String, open:String, close:String, dayInMonth:Int) {
        self.layer.cornerRadius = 10;

        self.backgroundColor = UIColor.blueColor()
        
        //create a LABEL for day, opening time, closing time
        let dayOfweek = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        let dayOfMonth = UILabel(frame: CGRect(x: 0, y: 20, width: 100, height: 40))
        let openTime = UILabel(frame: CGRect(x: 0, y: 60, width: 100, height: 20))
        let closeTime = UILabel(frame: CGRect(x: 0, y: 80, width: 100, height: 20))
        

        //CENTER day of week, open time, close time
        dayOfMonth.textAlignment = NSTextAlignment.Center
        dayOfweek.textAlignment = NSTextAlignment.Center
        openTime.textAlignment = NSTextAlignment.Center
        closeTime.textAlignment = NSTextAlignment.Center
        
        //make day of month font size larger
        dayOfMonth.font = dayOfMonth.font.fontWithSize(40)
        

        //insert text
        dayOfMonth.text = "\(dayInMonth)"
        dayOfweek.text = "\(day)"
        openTime.text = "\(open)"
        closeTime.text = "\(close)"
        
        dayOfweek.backgroundColor = UIColor.yellowColor()
        
        self.addSubview(dayOfweek)
        self.addSubview(dayOfMonth)
        self.addSubview(openTime)
        self.addSubview(closeTime)
    
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

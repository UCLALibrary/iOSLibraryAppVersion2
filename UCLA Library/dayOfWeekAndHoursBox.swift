//
//  dayOfWeekAndHoursBox.swift
//  UCLA Library
//
//  Created by Regan Hsu on 3/20/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit

class dayOfWeekAndHoursBox: UIView {
    
    //create a LABEL for day, opening time, closing time
    let dayOfweek = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    let dayOfMonth = UILabel(frame: CGRect(x: 0, y: 20, width: 100, height: 40))
    let openTime = UILabel(frame: CGRect(x: 0, y: 60, width: 100, height: 20))
    let closeTime = UILabel(frame: CGRect(x: 0, y: 80, width: 100, height: 20))
    
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
        self.layer.cornerRadius = 5;

        self.backgroundColor = UIColor.init(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)

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
        
        //color of text
        dayOfMonth.textColor = UIColor.init(red: 0x1B/255, green: 0x8F/255, blue: 0xE8/255, alpha: 1)
        dayOfweek.textColor = UIColor.blackColor()
        openTime.textColor = UIColor.blackColor()
        closeTime.textColor = UIColor.blackColor()
        
        //add the components to the square
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

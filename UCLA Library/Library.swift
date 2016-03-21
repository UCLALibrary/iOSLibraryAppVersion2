//
//  Library.swift
//  UCLA Library
//
//  Created by Regan Hsu on 3/19/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit

struct dayInWeek {
    var name: String!
    var open: String!
    var close: String!

    
    init(name: String, open:String, close: String) {
        self.name = name
        self.open = open
        self.close = close
    }
}


class Library: NSObject {
    var name: String!
    var id: Int!
    var week:[dayInWeek]!
    
    
    init(name: String? = nil) {
        self.name = name
        self.id = nil
        
        //Swift doesn't support initializing an empty array of size 7 yet
        //the reason we are doing this is because the JSON recieved is out of order from Anumat's server
        //i.e {tuesday:"...", monday:"...", friday:"...",} etc.
        //this way we can directly hash into the array i.e if(monday) library.week[0] = "monday's value"
        //sorting is another option, but we would like to avoid the cpu of that
        var temp = dayInWeek(name:"",open:"",close:"")
        self.week = Array<dayInWeek>(count: 7, repeatedValue: temp)
        
        super.init()
    }
    
}

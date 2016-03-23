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
    var coordinates:(Float, Float)!
    
    
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
    
    
    
    func getCoordinates() {
        let sortDictionary: [String:(Float, Float)] = [
            "Arts Library" : (34.074079, -118.439218),
            "Biomedical Library" : (34.066639, -118.442408),
            "East Asian Library" : (34.074759, -118.441832),
            "Law Library" : (34.066639, -118.442408),
            "Library Special Collections" : (34.075112, -118.441485),
            "Management Library" : (34.07435, -118.443379),
            "Music Library" : (34.07094, -118.440417),
            "Powell Library" : (34.07162, -118.44218),
            "Research Library" : (34.074954, -118.44165),
            "Science and Engineering Library" : (34.068826, -118.442706),
            "Southern Regional Library Facility" : (34.070864, -118.454188)
        ]
        self.coordinates = sortDictionary[self.name]
    }
    
}

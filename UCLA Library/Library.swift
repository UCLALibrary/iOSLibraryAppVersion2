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
        self.week = []
        super.init()
    }
    
}

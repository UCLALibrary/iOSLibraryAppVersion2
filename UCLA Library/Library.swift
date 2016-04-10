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
    var dayOfMonth: Int!
    
    init(name: String, open:String, close: String, dayOfMonth: Int) {
        self.name = name
        self.open = open
        self.close = close
        self.dayOfMonth = dayOfMonth
    }
}


class Library: NSObject {
    var name: String!
    var id: Int!
    var week:[dayInWeek]!
    var coordinates:(Double, Double)!
    var availableLaptops: Int!
    var maximumLaptops: Int!
    var email:String!
    var phoneNumber:String!
    
    
    init(name: String? = nil) {
        self.name = name
        self.id = nil
        
        //Swift doesn't support initializing an empty array of size 7 yet
        //the reason we are doing this is because the JSON recieved is out of order from Anumat's server
        //i.e {tuesday:"...", monday:"...", friday:"...",} etc.
        //this way we can directly hash into the array i.e if(monday) library.week[0] = "monday's value"
        //sorting is another option, but we would like to avoid the cpu of that
        var temp = dayInWeek(name:"",open:"",close:"", dayOfMonth: 0)
        self.week = Array<dayInWeek>(count: 7, repeatedValue: temp)
        
        super.init()
    }
    
    
    //return the state of the phone: open, closed, or about to close in string form.
    //future developers: maybe use enums instead?
    func getState() -> String {
        let calendar = NSCalendar.currentCalendar()
        let currentDate = NSDate()
        let dateComponents = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Day], fromDate: currentDate)
        
        //access day in week array
        let indexIntoDayArray = dateComponents.day - week[0].dayOfMonth
        let close = week[indexIntoDayArray].close
        
        //if closed today, simply return closed
        if (close == "closed") {
            return "closed"
        }
        
        //algo to isolate the number from the string format that is returned from server
        //split the string into an array
        let components = close.componentsSeparatedByString(" ")
        
        //first element is the closing time in HH:MM
        var closingHour = Int(components[0].componentsSeparatedByString(":")[0])
        
        //if its PM make sure to add 12
        if(components[1] == "PM") {
            closingHour = closingHour! + 12
        }
        
        if(dateComponents.hour > closingHour) {
            return "closed"
        } else if (dateComponents.hour == closingHour! - 1) {
            return "closing soon"
        } else {
            return "open"
        }
        
        
    }
    
    
    //return a tuple where first is open time, second is closing time
    func getHoursToday() -> (String, String) {
        let calendar = NSCalendar.currentCalendar()
        let currentDate = NSDate()
        let dateComponents = calendar.components([NSCalendarUnit.Day], fromDate: currentDate)
        
        //access day in week array
        let indexIntoDayArray = dateComponents.day - week[0].dayOfMonth
        let open = week[indexIntoDayArray].open
        let close = week[indexIntoDayArray].close
        return (open, close)
    }
    
    
    func getCoordinates() {
        let mydictionary: [String:(Double, Double)] = [
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
        self.coordinates = mydictionary[self.name]
    }
    
    
    func getImagePath() -> String {
        let mydictionary: [String:String] = [
            "Arts Library" : "ArtsLibrary.png",
            "Biomedical Library" : "BiomedicalLibrary.png",
            "East Asian Library" : "EastAsianLibrary.png",
            "Law Library" : "LawLibrary.jpg",
            "Library Special Collections" : "ManagementLibrary.jpg",
            "Management Library" : "ManagementLibrary.png",
            "Music Library" : "MusicLibrary.jpg",
            "Powell Library" : "PowellLibrary.png",
            "Research Library" : "ResearchLibrary.png",
            "Science and Engineering Library" : "ScienceandEngineeringLibrary.png",
            "Southern Regional Library Facility" : "SouthernRegionalLibraryFacility.jpg"
        ]
        return mydictionary[self.name]!
    }
    
    func getMaxLaptops() {
        let mydictionary: [String:Int] = [
            "Arts Library" : 11,
            "Biomedical Library" : 32,
            "East Asian Library" : 0,
            "Law Library" : 0,
            "Library Special Collections" : 0,
            "Management Library" : 0,
            "Music Library" : 12,
            "Powell Library" : 92,
            "Research Library" : 90,
            "Science and Engineering Library" : 45,
            "Southern Regional Library Facility" : 0
        ]
        self.maximumLaptops = mydictionary[self.name]

    }
    
    func getContactDetails() {
        let mydictionary: [String:(String, String)] = [
            "Arts Library" : ("3102065425","arts-ref@library.ucla.edu"),
            "Biomedical Library" : ("3108254904","biomed-ref@library.ucla.edu"),
            "East Asian Library" : ("3108254836",""),
            "Law Library" : ("3108254743",""),
            "Library Special Collections" : ("3108254988","spec-coll@library.ucla.edu"),
            "Management Library" : ("3108253138",""),
            "Music Library" : ("3108254882","music-ref@library.ucla.edu"),
            "Powell Library" : ("3108251938","ask.powell@library.ucla.edu"),
            "Research Library" : ("3108254732"," yrl-circ@library.ucla.edu"),
            "Science and Engineering Library" : ("3108254951","sel-ref@library.ucla.edu"),
            "Southern Regional Library Facility" : ("3102065425","srlf-request@library.ucla.edu")
        ]
        
        self.phoneNumber = mydictionary[self.name]?.0
        self.email = mydictionary[self.name]?.1
        
    }
    
}

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
    var name: String! //name of library
    var id: Int! //id of library
    var week:[dayInWeek]! //contains seven days
    var todayElement:Int! //today's day (filled when getState() is called
    var coordinates:(Double, Double)! //for googleMaps
    var availableLaptops: Int! //number of available laptops
    var maximumLaptops: Int! //maximum number of laptops
    var email:String! //email of the library
    var phoneNumber:String! //phone Number of the library
    
    init(name: String? = nil) {
        self.name = name
        self.id = nil
        
        //Swift doesn't support initializing an empty array of size 7 yet
        //the reason we are doing this is because the JSON recieved is out of order from Anumat's server
        //i.e {tuesday:"...", monday:"...", friday:"...",} etc.
        //this way we can directly hash into the array i.e if(monday) library.week[0] = "monday's value"
        //sorting is another option, but we would like to avoid the cpu of that
        let temp = dayInWeek(name:"",open:"",close:"", dayOfMonth: 0)
        self.week = Array<dayInWeek>(repeating: temp, count: 7)
        super.init()
    }
    
    //return the state of the phone: open, closed, or about to close in string form.
    //also populates todayElement
    //future developers: maybe use enums instead?
    //adjust time scale to 0 - 24 instead of 12am 12pm etc
    func getState() -> String {
        let currentDayInfo = getTodayInfo()
        let indexIntoDayArray = currentDayInfo.0
        let currentTime = currentDayInfo.1
        
        let close = indexIntoDayArray > -1 && indexIntoDayArray < 7 ? week[indexIntoDayArray].close : week[0].close
        let open = indexIntoDayArray > -1 && indexIntoDayArray < 7 ? week[indexIntoDayArray].open : week[0].open
        self.todayElement = indexIntoDayArray > -1 && indexIntoDayArray < 7 ? indexIntoDayArray : -1 //-1 means that anumat's API is broken
//        print("close: \(close)")
//        print("open: \(open)")
        
        //if closed today, simply return closed
        if (close == "closed") {
            return "closed"
        }
        
    //algo to isolate the number from the string format that is returned from server
        //split the string into an array
        let componentsOpen = open?.components(separatedBy: " ")
        let componentsClose = close?.components(separatedBy: " ")
        
        //first element is the componentsClose time in HH:MM
        var openTime = Double((componentsOpen?[0].components(separatedBy: ":")[0])!)! + Double((componentsOpen?[0].components(separatedBy: ":")[1])!)!/60
        
        var closeTime = Double((componentsClose?[0].components(separatedBy: ":")[0])!)! + Double((componentsClose?[0].components(separatedBy: ":")[1])!)!/60
        
        /****
         11am - 9pm check
         6am - 11am check
         5pm - 2am -> 17 , 2 -> closed [2, 17] -> closed [close, open]
         11am - 2am -> 11 , 2 -> closed [2, 11]
         6am - 3am -> 6, 3 -> closed [3, 6]
         9am - 12am -> 9, 0 -> closed [9, 12]
        *****/
        
        //if its PM make sure to add 12
        if(componentsClose?[1] == "PM") { //|| (componentsClose[1] == "AM" && closeTime - 12 < 1)) { - no longer needed bc of closes in the AM case
            closeTime = closeTime + 12
        }
        
        if(componentsOpen?[1] == "PM") {
            openTime = openTime + 12
        }
        
        //library closes in the AM
        if(componentsClose?[1] == "AM") {
            //closing case
            if(closeTime < currentTime && currentTime < openTime) {
                return "closed"
            } else if(closeTime - 1 < currentTime && currentTime < openTime) {
                return "closing soon"
            } else {
                return "open"
            }
        }
         
        if(currentTime > closeTime || currentTime < openTime) {
            return "closed"
        } else if (currentTime > closeTime - 1) {
            return "closing soon"
        } else {
            return "open"
        }
    }
    
    //return a tuple where first is open time, second is closing time
    func getHoursToday() -> (String, String) {
        let indexIntoDayArray = getTodayInfo().0
        if(indexIntoDayArray < 0 || indexIntoDayArray > 6) {
            return (week[0].open, week[0].close)
        }
        //print("the index is \(indexIntoDayArray)")
        return (week[indexIntoDayArray].open, week[indexIntoDayArray].close)
    }
    
    
    //get index into the current day and the Current Time
    fileprivate func getTodayInfo() -> (Int,Double) {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.day], from: currentDate)
        
        //access day in week array
        var indexIntoDayArray = dateComponents.day! - self.week[0].dayOfMonth
        if(indexIntoDayArray < 0) {
            indexIntoDayArray = 0
            while dateComponents.day != self.week[indexIntoDayArray].dayOfMonth {
                indexIntoDayArray += 1
            }
        }
        let currentTime = Double(dateComponents.hour!) + Double(dateComponents.minute!)/60
        
        return (indexIntoDayArray, currentTime)
    }
    
    
    func getName() -> String {
        let mydictionary: [String:String] = [
            "Arts Library" : "Arts",
            "Biomedical Library" : "Biomedical",
            "East Asian Library" : "East Asian",
            "Law Library" : "Law",
            "Library Special Collections" : "Special Collections",
            "Management Library" : "Management",
            "Music Library" : "Music",
            "Powell Library" : "Powell",
            "Research Library" : "Young Research",
            "Science and Engineering Library" : "Science & Engineering",
            "Southern Regional Library Facility" : "Southern Regional"
        ]
        return mydictionary[self.name]!
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
            "Library Special Collections" : "ResearchLibrary.png",
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
            "Music Library" : 13,
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

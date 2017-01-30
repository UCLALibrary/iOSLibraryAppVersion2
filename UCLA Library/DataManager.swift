//
//  DataManager.swift
//  UCLA Library
//
//  Created by Regan Hsu on 1/29/17.
//  Copyright © 2017 Regan Hsu. All rights reserved.
//

import Foundation
import Alamofire

class DataManager: NSObject {
    
    let weeklyLibraryData = "https://webservices.library.ucla.edu/calendar/hours/weekly/0/weeks/1"
    func getLibraryData() {
        //Using Alamofire to make a GET Request
        Alamofire.request(.GET, self.weeklyLibraryData).responseJSON {
                response in switch response.result {
                case .Success(let JSON):
                    print("success w/ new DataManager!");
                    if let response = JSON as? NSDictionary {
                        self.createLibraryObjects(response)
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func createLibraryObjects(libraryJSONData:NSDictionary) {
        var LibraryInformation = libraryJSONData["locations"] as! NSArray
    }
}
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
        Alamofire.request(.GET, self.weeklyLibraryData).responseJSON {
                response in switch response.result {
                case .Success(let JSON):
                    print("success w/ new DataManager!");
                    //let data = JSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                    
//                    if let response = JSON as? NSDictionary {
//                        self.createLibraryObjects(response)
//                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func createLibraryObjects(libraryJSONData:NSDictionary) {
        let libraries = libraryJSONData["locations"] as! NSArray
        for library in libraries {
            if let library = library as? NSDictionary {
                let name = library["name"] as! String
                let weeks = library["weeks"] as! NSArray
                print(name)
                print(weeks)
            }
        }
    }
    
    
}
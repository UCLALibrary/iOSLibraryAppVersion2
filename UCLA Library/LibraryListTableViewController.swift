//
//  LibraryListTableViewController.swift
//  UCLA Library
//
//  Created by Regan Hsu on 3/19/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit
import Alamofire

class LibraryListTableViewController: UITableViewController {
    
    var libraries:[Library] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //make font color white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //library logo
        let image = UIImage(named: "title.png")!
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150/1.1, height: 30/1.1))
        imageView.center.x = self.view.center.x
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        
        //color the navbar
        let fancySwiftColor = UIColor.init(red: 27/255, green: 143/255, blue: 232/255, alpha: 1)
        self.navigationController!.navigationBar.barTintColor = fancySwiftColor
        self.navigationController!.navigationBar.translucent = false

    }
    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBar.translucent = false
//    }
    
    override func viewDidAppear(animated: Bool) {
        self.getLibraryData()
        //self.openClosingOrSoon()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.libraries.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //mke cell reusable
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell's look
        let library = self.libraries[indexPath.row]
        
        //label the library's name, open to closing time
        cell.textLabel?.text = library.getName()

        //let imagePath = self.library.getImagePath()
        //self.imageView.image = UIImage(named: imagePath)
        
        let libState = library.getState()
        
        
        print("\(library.name) has state \(libState)")
        
        //depending on the state of the library, a certain 'close', 'open', or 'closing soon' icon will appear on the right of each row of the table
        if(libState == "open") {
            var icon = UIImageView(image: UIImage(named: "open.png"))
            icon.frame = CGRect(x: cell.frame.maxX - 50, y: cell.bounds.minY+10, width: 30, height: 30)
            cell.accessoryView = icon
            //cell.addSubview(icon)
           // icon.image =
        } else if(libState == "closing soon") {
            var icon = UIImageView(image: UIImage(named: "soon.png"))
            icon.frame = CGRect(x: cell.frame.maxX - 50, y: cell.bounds.minY+10, width: 30, height: 30)
            cell.accessoryView = icon
        } else if(libState == "closed") {
            var icon = UIImageView(image: UIImage(named: "close.png"))
            icon.frame = CGRect(x: cell.frame.maxX - 50, y: cell.bounds.minY+10, width: 30, height: 30)
            cell.accessoryView = icon
        }
        
        //cell.addSubview(stateIcon)
        
        let hours = library.getHoursToday()
        cell.detailTextLabel?.text = "\(hours.0) - \(hours.1)"

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //retrieve indexPath of selected cell
        //bc our segue is triggered only when a user taps on a cell, we kno that sendder object is always going to be a UITableViewCell, so we force downcast it w/ as!
        
        //transfer data from one controller to the other
        if(segue.identifier == "ToDetailView") {
            let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
            let library = self.libraries[indexPath.row]
            let destination = segue.destinationViewController as! DetailViewController
            destination.library = library
        }
        else if(segue.identifier == "ToMenu") {
            //to menu
        }

        
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    //Regan's Functions
    ////////////////////////////////////////////////////////////////////////////////////
    
    func getLibraryData() {
        
        let sortDictionary: [String:Int] = [
            "monday" : 0,
            "tuesday" : 1,
            "wednesday" : 2,
            "thursday" : 3,
            "friday" : 4,
            "saturday" : 5,
            "sunday" : 6
        ]
        
        
        //Using Alamofire to make a getRequest
        Alamofire.request(.GET, "http://anumat.com/hours")
            .responseJSON {
                response in switch response.result {
                case .Success(let JSON):
                    
                    var localLibraries:[Library] = []
                    
                    //if let chain is to ensure SECURE unwraping
                    //Don't believe me? look @ apple docs
                    //do not think this is superfluous, without it the app could easily crash
                    //do not think that you can just force unwrap with 'as!'
                    if let response = JSON as? NSArray {
                        for lib in response {
                            if let curr = lib as? NSDictionary {
                                var currentLibrary = Library()
                                
                                //iterating thru JSON response via pattern matching, like ocaml/ML
                                for (key, value) in curr {
                                    
                                    //tempKey will be either be the day of the week, the ID of the library, or name of library
                                    if let tempKey = key as? String {
                                        
                                        //if the key is the ID of the library
                                        if tempKey == "id" {
                                            if let idValue = value as? String {
                                                currentLibrary.id = Int(idValue) as Int!
                                            }
                                        }
                                            
                                        //if the key is the NAME of the library
                                        else if tempKey == "name" {
                                            if let libraryName = value as? String {
                                                currentLibrary.name = libraryName as String!
                                                currentLibrary.getCoordinates()
                                                currentLibrary.getMaxLaptops()
                                                currentLibrary.getContactDetails()
                                                
                                            }
                                        }
                                            
                                        //if the key is the NUMBER of laptops available
                                        else if tempKey == "laptops" {
                                            if let nLaptops = value as? Int {
                                                currentLibrary.availableLaptops = nLaptops as Int!
                                            }
                                        }
                                        
                                        else {
                                            
                                            //if the key is the DAY of the week
                                            if let dayOfWeek = value as? NSDictionary {
                                                
                                                //get the opening & closing times
                                                if let open = dayOfWeek["open"] as? String {
                                                    if let close = dayOfWeek["close"] as? String {
                                                        
                                                        //get day of month
                                                        if let dayOfMonth = dayOfWeek["date"] as? Int {

                                                            //create a day struct storing open and close of M T W Th F S Sn
                                                            let day = dayInWeek(name: tempKey.capitalizedString, open: open, close: close, dayOfMonth: dayOfMonth)
                                                            
                                                            //store that into the library's day array
                                                            //we are doing this because the JSON result by day is out of order (M T W Th F Sn out of order)
                                                            currentLibrary.week[sortDictionary["\(tempKey)"]!] = day
                                                        }
                                                    
                                                    }
                                                }
                                            }
                                        }
                                        
                                        
                                    }
                                }
                                
                                //append the library to currentLibrary
                                localLibraries.append(currentLibrary)
                            }
                            
                        }
                        
                        self.libraries = localLibraries
                        
                        
                        //refresh Table in the TableView since this GET request is ASYNCHRONOUS
                        self.refreshTable()
                        
                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
    }
    
    //function to refresh Table since the GET request used is ASYNCHRONOUS
    func refreshTable()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    
//////////////////////////////////////
//
//////////////////////////////////////
    
    enum LibraryState {
        case ClosingSoon
        case Open
        case Close
    }
    
    //library:Library
    func openClosingOrSoon() -> LibraryState {
        var state = LibraryState.Open

        
        let calendar = NSCalendar.currentCalendar()
        
        //print("the day is \(day), the month is \(month)")
        let currentDate = NSDate()
        let dateComponents = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond], fromDate: currentDate)
        
        print("day = \(dateComponents.day)", "month = \(dateComponents.month)", "year = \(dateComponents.year)", "week of year = \(dateComponents.weekOfYear)", "hour = \(dateComponents.hour)", "minute = \(dateComponents.minute)", "second = \(dateComponents.second)", "nanosecond = \(dateComponents.nanosecond)" , separator: ", ", terminator: "")
        
        return state
    }
    
    

}

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
        
        self.view.backgroundColor = UIColor.blueColor()
        
        //library logo
        let image = UIImage(named: "logo.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150/1.1, height: 30/1.1))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        
        //get data from Anumat's server
        self.getLibraryData()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getLibraryData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell's look
        let library = self.libraries[indexPath.row]
        cell.backgroundColor = UIColor.whiteColor()
        cell.contentView.backgroundColor = UIColor.greenColor()

        
        //label the cell's details
        if let name = library.name {
            cell.textLabel?.text = name
            if let open = library.week[0].open {
                if let close = library.week[0].close {
                    cell.detailTextLabel?.text = open + " - " + close
                    //cell.OpenIndicator
                }
            }
        } else {
            cell.textLabel?.text = "No name"
        }

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
        let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
        let library = self.libraries[indexPath.row]
        let destination = segue.destinationViewController as! DetailViewController
        
        destination.library = library
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
                                                            let day = dayInWeek(name: tempKey, open: open, close: close, dayOfMonth: dayOfMonth)
                                                            
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
    

}

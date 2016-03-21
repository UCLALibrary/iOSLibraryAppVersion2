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
        self.getLibraryData()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

        // Configure the cell...
        let library = self.libraries[indexPath.row]
        
        if let name = library.name {
            cell.textLabel?.text = name
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
        //Using Alamofire to make a getRequest
        Alamofire.request(.GET, "http://anumat.com/hours")
            .responseJSON {
                response in switch response.result {
                case .Success(let JSON):
                    
                    
                    //if let chain is to ensure SECURE unwraping
                    //Don't believe me? look @ apple docs
                    //do not think this is superfluous, without it the app could easily crash
                    //do not think that you can just force unwrap with as!
                    if let response = JSON as? NSArray {
                        for lib in response {
                            if let curr = lib as? NSDictionary {
                                var currentLibrary = Library()
                                
                                //pattern matching, like ocaml/ML
                                for (key, value) in curr {
                                    if let tempKey = key as? String {
                                        
                                        //get the ID of the library
                                        if tempKey == "id" {
                                            if let idValue = value as? String {
                                                currentLibrary.id = Int(idValue) as Int!
                                            }
                                        }
                                            
                                        //get the NAME of the library
                                        else if tempKey == "name" {
                                            if let libraryName = value as? String {
                                                currentLibrary.name = libraryName as String!
                                            }
                                        }
                                        
                                        else {
                                            
                                            //get the DAY of the week
                                            if let dayOfWeek = value as? NSDictionary {
                                                
                                                //get the opening & closing time
                                                if let open = dayOfWeek["open"] as? String {
                                                    if let close = dayOfWeek["close"] as? String {
                                                        
                                                        let day = dayInWeek(name: tempKey, open: open, close: close)
                                                        currentLibrary.week.append(day)
                                                    
                                                    }
                                                }
                                            }
                                        }
                                        
                                        
                                    }
                                }
                                
                                //append the library to currentLibrary
                                self.libraries.append(currentLibrary)
                            }
                            
                        }
                        
                        
                        //refresh Table since this GET request is ASYNCHRONOUS
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

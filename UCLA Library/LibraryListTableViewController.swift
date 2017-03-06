//
//  LibraryListTableViewController.swift
//  UCLA Library
//
//  Created by Regan Hsu on 3/19/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit
import Alamofire
import Google

class LibraryListTableViewController: UITableViewController {
    
    var libraries:[Library] = []
    
    //instantiate a gray Activity Indicator View
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //make font color white
        UIApplication.shared.statusBarStyle = .lightContent
        
        //library logo
        let image = UIImage(named: "title.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150/1.1, height: 30/1.1))
        imageView.center.x = self.view.center.x
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        
        //color the navbar
        self.navigationController!.navigationBar.barTintColor = themeColor
        self.navigationController!.navigationBar.isTranslucent = false
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.backgroundColor = UIColor.white

        //progress indicator
        //add the activity to the ViewController's view
        view.addSubview(activityIndicatorView)
        //position the Activity Indicator View in the center of the view
        activityIndicatorView.center = view.center
        //tell the Activity Indicator View to begin animating
        activityIndicatorView.startAnimating()

    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        let name =  "hello"
        // let name = "Pattern~\(self.title!)"
        
        // The UA-XXXXX-Y tracker ID is loaded automatically from the
        // GoogleService-Info.plist by the `GGLContext` in the AppDelegate.
        // If you're copying this to an app just using Analytics, you'll
        // need to configure your tracking ID here.
        // [START screen_view_hit_swift]
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        let build = builder?.build() as NSDictionary? as? [AnyHashable: Any] ?? [:]
        tracker?.send(build)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getLibraryData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.libraries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //mke cell reusable
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell's look
        let library = self.libraries[indexPath.row]
        
        //label the library's name, open to closing time
        cell.textLabel?.text = library.getName()

        //for each row, we need to know if the library is closing soon (< 1 hr left), closed, or open
        let libState = library.getState()
                
        //depending on the state of the library, a certain 'close', 'open', or 'closing soon' icon will appear on the right of each row of the table
        if(libState == "open") {
            let icon = UIImageView(image: UIImage(named: "open.png"))
            icon.frame = CGRect(x: cell.frame.maxX - 50, y: cell.bounds.minY+10, width: 30, height: 30)
            cell.accessoryView = icon
        } else if(libState == "closing soon") {
            let icon = UIImageView(image: UIImage(named: "soon.png"))
            icon.frame = CGRect(x: cell.frame.maxX - 50, y: cell.bounds.minY+10, width: 30, height: 30)
            cell.accessoryView = icon
        } else if(libState == "closed") {
            let icon = UIImageView(image: UIImage(named: "close.png"))
            icon.frame = CGRect(x: cell.frame.maxX - 50, y: cell.bounds.minY+10, width: 30, height: 30)
            cell.accessoryView = icon
        }
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //retrieve indexPath of selected cell
        //bc our segue is triggered only when a user taps on a cell, we kno that sendder object is always going to be a UITableViewCell, so we force downcast it w/ as!
        
        //transfer data from one controller to the other
        if(segue.identifier == "ToDetailView") {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
            let library = self.libraries[indexPath.row]
            let detailViewOfLibrary = segue.destination as! DetailViewController
            detailViewOfLibrary.library = library
            
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
        
        
        //Using Alamofire to make a GET Request
        Alamofire.request("http://anumat.com/hours")
            .responseJSON {
                response in switch response.result {
                case .success(let JSON):
                    
                    var localLibraries:[Library] = []
                    
                    //if let chain is to ensure SECURE unwraping
                    //Don't believe me? look @ apple docs
                    //do not think this is superfluous, without it the app could easily crash
                    //do not think that you can just force unwrap with 'as!'
                    if let response = JSON as? NSArray {
                        for lib in response {
                            if let curr = lib as? NSDictionary {
                                let currentLibrary = Library()
                                
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
                                                            let day = dayInWeek(name: tempKey.capitalized, open: open, close: close, dayOfMonth: dayOfMonth)
                                                            //store that into the library's day array
                                                            //we are doing this because the JSON result by day is out of order (M T W Th F Sn out of order)
                                                            currentLibrary.week[sortDictionary["\(tempKey)"]!] = day
                                                        }
                                                    
                                                    }
                                                }
                                            } else {
                                                //library has no hours
                                                currentLibrary.name = nil
                                                break
                                            }
                                        }
                                    }
                                }
                                if(currentLibrary.name != nil) {
                                    //append the library to currentLibrary
                                    localLibraries.append(currentLibrary)
                                }
                            }
                            
                        }

                        self.libraries = localLibraries
                        
                        //remove activity indicator view
                        self.activityIndicatorView.removeFromSuperview()
                        
                        //refresh Table in the TableView since this GET request is ASYNCHRONOUS
                        self.refreshTable()
                        
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
    }
    
    //function to refresh Table since the GET request used is ASYNCHRONOUS
    func refreshTable()
    {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            return
        })
    }
}

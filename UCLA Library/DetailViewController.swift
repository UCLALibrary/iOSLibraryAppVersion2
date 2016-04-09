//
//  DetailViewController.swift
//  UCLA Library
//
//  Created by Regan Hsu on 3/20/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var mapView: UIView!
    @IBOutlet var phoneAndEmailView: UIView!
    //@IBOutlet var phoneView: UIView!
    //@IBOutlet var emailView: UIView!
    var progress: KDCircularProgress!
    var library: Library!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make font color white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Do any additional setup after loading the view.
        if let library = self.library {
            if let name = library.name {
                
                //change the back button color
                self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
                
                //cange the title color
                navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                
                self.navigationItem.title = name
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.translucent = true
                self.navigationController?.view.backgroundColor = UIColor.clearColor()
            }
        }


        
/////////////////////////
//Days of week and corresponding hours
/////////////////////////
        self.scrollView.backgroundColor = UIColor.redColor()
        
        //1010 specifies the overall width of the scroll view (which extends beyond the screen)
        self.scrollView.contentSize = CGSizeMake(800, self.scrollView.frame.size.height)
        
        //disable vertical scrolling
        self.automaticallyAdjustsScrollViewInsets = false;
        
        //7 days in week
        //POPULATE the scrollview with tiles showing the day and hours open
        for i in 0..<7 {
            let day = self.library?.week[i] as dayInWeek!
            let name = day.name
            let open = day.open
            let close = day.close
            let dayOfMonth = day.dayOfMonth
            
            let tileInScroll = dayOfWeekAndHoursBox(frame: CGRect(origin: CGPoint(x:20+i*110, y:0), size: CGSize(width: self.scrollView.frame.size.height, height: self.scrollView.frame.size.height)), dayOfweek:name, open:open, close:close, dayOfMonth: dayOfMonth)
            
            self.scrollView.addSubview(tileInScroll)
            

        }
        
        
/////////////////////////
//Image of library
/////////////////////////
        //set image of the library
        let imagePath = self.library.getImagePath()
        self.imageView.image = UIImage(named: imagePath)
        
        //crop image instead of scaling
        self.imageView.clipsToBounds = true;

        
        
/////////////////////////
//Contact email and phone Number
/////////////////////////
        
        //set the contact details backgroundcolor 
        //self.contactLabel.backgroundColor = UIColor.redColor()
        //let phoneNumberView = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.width/2, height: self.phoneAndEmailView.bounds.height)))
        
        //phoneNumberView.backgroundColor = UIColor.yellowColor()
        //phoneNumberView.textAlignment =  NSTextAlignment.Center
        //phoneNumberView.text = UIApplication.sharedApplication().openURL(NSURL(string:"telprompt:0123456789"))

            //self.library.phoneNumber
        //phoneNumberView.backgroundColor = UIColor.yellowColor()
        //self.phoneAndEmailView.addSubview(phoneNumberView)

//        self.phoneAndEmailView.backgroundColor = UIColor.blackColor()
        
        //if there is an email
//        if(self.library.email != "") {
//            let emailView = UILabel(frame: CGRect(origin: CGPoint(x: self.view.bounds.width/2, y: 0), size: CGSize(width: self.view.bounds.width/2, height: self.phoneAndEmailView.bounds.height)))
//            
//            emailView.backgroundColor = UIColor.yellowColor()
//            emailView.textAlignment =  NSTextAlignment.Center
//            emailView.text = self.library.email
//            emailView.backgroundColor = UIColor.grayColor()
//            self.phoneAndEmailView.addSubview(emailView)
//            self.phoneAndEmailView.addSubview(emailView)
//            //self.contactLabel.text = "\(self.library.phoneNumber) | \(self.library.email)"
//        }
// 
/////////////////////////
//googleMaps
/////////////////////////
        let camera = GMSCameraPosition.cameraWithLatitude(library.coordinates.0,
            longitude:library.coordinates.1, zoom:15)
       
        let location = GMSMapView.mapWithFrame(CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height), camera:camera)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = self.library.name
        marker.map = location
        
        
        self.mapView.addSubview(location)
        
        
        
/////////////////////////
//Circular Progress Circle
/////////////////////////
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        progress.startAngle = -90
        progress.progressThickness = 0.1
        progress.trackThickness = 0.1
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .Forward
        progress.glowAmount = 0.9
        progress.setColors(UIColor.whiteColor())
        progress.center = CGPoint(x: view.center.x, y: self.imageView.center.y)

    }
    
    override func viewDidAppear(animated: Bool) {
        
        //library has laptops for lending
        if self.library.maximumLaptops != 0 {
            let percentOfLaptopsAvailable = Double(self.library.availableLaptops)/Double(self.library.maximumLaptops)
            let angle = Int(360*percentOfLaptopsAvailable)
            self.imageView.addSubview(progress)
        
            //adding uilabel
            var nLaptops = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            nLaptops.center = CGPoint(x: self.progress.center.x, y: self.progress.center.y)
            nLaptops.numberOfLines = 2
            nLaptops.text = "\(self.library.availableLaptops) \n" + "Laptops"
            nLaptops.textColor = UIColor.whiteColor()
            //nLaptops.backgroundColor = UIColor.purpleColor()
            nLaptops.textAlignment = NSTextAlignment.Center
            
            
            //nLaptops.textAlignment = UITextAlignmentLeft
            
            self.imageView.addSubview(nLaptops)
            
            progress.animateFromAngle(0, toAngle: angle, duration: 3) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
        }
        
        
        
    }
    
    
    //make status bar change font color back to black
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

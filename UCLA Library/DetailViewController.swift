//
//  DetailViewController.swift
//  UCLA Library
//
//  Created by Regan Hsu on 3/20/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMaps


//subclassing this controller with the regular viewcontroller AND email delegate cause we be sendin some emails
class DetailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var mapView: UIView!
    var progress: KDCircularProgress!
    var library: Library!
    @IBOutlet var GmapView: UIView!
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var emailButton: UIButton!
        
    // Delegate requirement
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    //Button to call phone
    @IBAction func callLibrary(sender: AnyObject) {
        callNumber(self.library.phoneNumber)
    }
    
    //Button to send email
    @IBAction func emailLibrary(sender: AnyObject) {
        // Create email message
        var email = MFMailComposeViewController()
        email.mailComposeDelegate = self
        email.setToRecipients([self.library.email])
        email.setSubject("Library Inquiry")
        //email.setMessageBody("Some example text", isHTML: false) // or true, if you prefer
        presentViewController(email, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //google maps
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.GmapView.frame.size.height = screenSize.height - self.GmapView.frame.minY
        
        //make phone and email buttons colorful
        self.phoneButton.backgroundColor = UIColor.greenColor()
        self.emailButton.backgroundColor = UIColor.cyanColor()
        
        //make font color white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //change the back button color
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        //change the title color
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //add image to view and make changes to image
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        
        
        //add library name to title
        self.navigationItem.title = self.library.name
        

        
/////////////////////////
//Days of week and corresponding hours
/////////////////////////
        
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
            
            let tileInScroll = dayOfWeekAndHoursBox(frame: CGRect(origin: CGPoint(x:10+i*110, y:0), size: CGSize(width: self.scrollView.frame.size.height, height: self.scrollView.frame.size.height)), dayOfweek:name, open:open, close:close, dayOfMonth: dayOfMonth)
            
            self.scrollView.addSubview(tileInScroll)
        }

        //automatically scroll to the current day
        //self.scrollView.contentOffset = CGPoint(x: 50, y: 0)
    
        

        
/////////////////////////
//Image of library
/////////////////////////
        //set image of the library
        let imagePath = self.library.getImagePath()
        self.imageView.image = UIImage(named: imagePath)
        
        //crop image instead of scaling
        self.imageView.clipsToBounds = true;


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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = true
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
            nLaptops.textAlignment = NSTextAlignment.Center
            
            
            //nLaptops.textAlignment = UITextAlignmentLeft
            
            self.imageView.addSubview(nLaptops)
            
            progress.animateFromAngle(0, toAngle: angle, duration: 1.5) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
        }
        
    }
    
/////////////////////////
//Other housekeeping
/////////////////////////
    
    //make status bar change font color back to white
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.translucent = false

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //call phone number
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    //send email
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

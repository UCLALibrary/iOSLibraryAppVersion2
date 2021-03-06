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
    @IBOutlet var backgroundEmailPhone: UIView!
    @IBOutlet var leadingContraint: NSLayoutConstraint!
    @IBOutlet var widthOfButtonContainer: NSLayoutConstraint!
    
    // Delegate requirement
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    //Button to call phone
    @IBAction func callLibrary(_ sender: AnyObject) {
        callNumber(self.library.phoneNumber)
    }
    
    //Button to send email
    @IBAction func emailLibrary(_ sender: AnyObject) {
        // Create email message
        let email = MFMailComposeViewController()
        email.mailComposeDelegate = self
        email.setToRecipients([self.library.email])
        email.setSubject("Library Inquiry")
        //email.setMessageBody("Some example text", isHTML: false) // or true, if you prefer
        present(email, animated: true, completion: nil)
    }
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make font color white
        UIApplication.shared.statusBarStyle = .lightContent
        
        //change the back button color
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        //change the title color
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //add image to view and make changes to image
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //add library name to title
        self.navigationItem.title = self.library.name
        
        /////////////////////////
        //Days of week and corresponding hours
        /////////////////////////
        
        //780 specifies the overall width of the scroll view (which extends beyond the screen)
        self.scrollView.contentSize = CGSize(width: 780, height: self.scrollView.frame.size.height)
        
        //disable vertical scrolling
        self.automaticallyAdjustsScrollViewInsets = false;
        
        //POPULATE the scrollview with tiles showing the day and hours open and scroll to day
        populateDaysOfWeek()
        
        //set image of the library
        let imagePath = self.library.getImagePath()
        self.imageView.image = UIImage(named: imagePath)
        //crop image instead of scaling
        self.imageView.clipsToBounds = true;
        
        //set progress view settings
        setProgressWheelSettings()
        
        //remove email button for those without emails
        if(self.library.email == "") {
            self.emailButton.removeFromSuperview()
            self.leadingContraint.constant = UIScreen.main.bounds.width/4 + 10 //- self.emailButton.frame.width/2
            self.backgroundEmailPhone.removeConstraint(widthOfButtonContainer)
            //self.backgroundEmailPhone.backgroundColor = UIColor.yellowColor()
            self.backgroundEmailPhone.frame.insetBy(dx: 100, dy: 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //library has laptops for lending
        if self.library.maximumLaptops != 0 {
            var percentOfLaptopsAvailable = Double(self.library.availableLaptops)/Double(self.library.maximumLaptops)
            //in the case that a library has more laptops than the maximum number
            //TODO: a routine to retrieve the maximum number of laptops
            if (percentOfLaptopsAvailable > 1) {
                percentOfLaptopsAvailable = 1
            }
            let angle = Int(360*percentOfLaptopsAvailable)
            self.imageView.addSubview(progress)
            
            //adding uilabel
            let nLaptops = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            nLaptops.center = CGPoint(x: self.progress.center.x, y: self.progress.center.y)
            nLaptops.numberOfLines = 2
            nLaptops.text = "\(self.library.availableLaptops!) \n" + "Laptops"
            nLaptops.textColor = UIColor.white
            nLaptops.textAlignment = NSTextAlignment.center
            self.imageView.addSubview(nLaptops)
            
            progress.animateFromAngle(0, toAngle: angle, duration: 1.5) { completed in
            }
        }
    }
    
    // Only load Google Maps once the views of different devices have been correctly laid out
    override func viewDidLayoutSubviews() {
        loadGoogleMaps()
    }
    
    override func transition(from fromViewController: UIViewController, to toViewController: UIViewController, duration: TimeInterval, options: UIViewAnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // When the view will appear, make the navbar translucent
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // Make status bar change font color back to white
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    /////////////////////////
    //Circular Progress Circle
    /////////////////////////
    fileprivate func setProgressWheelSettings() {
        if self.library.maximumLaptops != 0 {
            progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            progress.startAngle = -90
            progress.progressThickness = 0.1
            progress.trackThickness = 0.1
            progress.clockwise = true
            progress.gradientRotateSpeed = 2
            progress.roundedCorners = false
            progress.glowMode = .forward
            progress.glowAmount = 0.9
            progress.setColors(UIColor.white)
            progress.center = CGPoint(x: view.center.x, y: self.imageView.center.y)
        }
    }
    
    /////////////////////////
    //Google Maps
    /////////////////////////
    fileprivate func loadGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: library.coordinates.0, longitude:library.coordinates.1, zoom:15)
        let location = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height), camera:camera)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = self.library.name
        marker.map = location
        self.mapView.addSubview(location)
    }
    
    /////////////////////////
    //Call a phone number
    /////////////////////////
    fileprivate func callNumber(_ phoneNumber:String) {
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    /////////////////////////
    //Populate days of week with info
    /////////////////////////
    fileprivate func populateDaysOfWeek() {
        for i in 0..<7 {
            let day = self.library?.week[i] as dayInWeek!
            let name = day?.name
            let open = day?.open
            let close = day?.close
            let dayOfMonth = day?.dayOfMonth
            let tileInScroll = dayOfWeekAndHoursBox(frame: CGRect(origin: CGPoint(x:10+i*110, y:0), size: CGSize(width: self.scrollView.frame.size.height, height: self.scrollView.frame.size.height)), dayOfweek:name!, open:open!, close:close!, dayOfMonth: dayOfMonth!)
            // Differentiate the box that represents today's date
            if(i == self.library.todayElement) {
                tileInScroll.dayOfMonth.textColor = UIColor.white
                tileInScroll.backgroundColor = themeColor
            }
            self.scrollView.addSubview(tileInScroll)
        }
        
        // Changed by Nathan - needs code review for Issue #12
        // Depending on the number of boxes we can fit per screen, set the content offset to automatically scroll to today's day
        if self.library.todayElement != -1
        {
            // Grab the number of complete boxes that fit on the screen size
            let screenWidth = UIScreen.main.bounds.width
            let boxesPerScreen = Int(screenWidth / 110)
            
            // If scrolling and making today's box the first box results in not reaching the end of the list yet, scroll there
            if self.library.todayElement < 7 - boxesPerScreen
            {
                self.scrollView.contentOffset.x = CGFloat(110 * self.library.todayElement)
            }
                
                // Otherwise if scrolling to today's day scrolls too far, then we would rather the scrollview just scroll to the end of the list and stop
            else
            {
                self.scrollView.contentOffset.x = scrollView.contentSize.width + scrollView.contentInset.right - scrollView.bounds.size.width
            }
        }
    }
}

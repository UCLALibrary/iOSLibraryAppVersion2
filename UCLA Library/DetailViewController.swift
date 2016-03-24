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
    
    
    var library: Library!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let library = self.library {
            if let name = library.name {
                self.navigationItem.title = name
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.translucent = true
                self.navigationController?.view.backgroundColor = UIColor.clearColor()
            }
        }


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
            self.scrollView.addSubview(dayOfWeekAndHoursBox(frame: CGRect(origin: CGPoint(x:20+i*110, y:0), size: CGSize(width: self.scrollView.frame.size.height, height: self.scrollView.frame.size.height)), dayOfweek:name ,open:open, close:close))

        }
        

        //set image of the library
        let imagePath = self.library.getImagePath()
        self.imageView.image = UIImage(named: imagePath)
        
        //crop image instead of scaling
        self.imageView.clipsToBounds = true;
        

        //googleMaps
        let camera = GMSCameraPosition.cameraWithLatitude(library.coordinates.0,
            longitude:library.coordinates.1, zoom:15)
       
        let location = GMSMapView.mapWithFrame(CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height), camera:camera)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        //marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = location
        
        
        self.mapView.addSubview(location)
        

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

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
    
    @IBOutlet var libraryMap: UIView!
    
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

        
        //set image of the library
        self.imageView.image = UIImage(named: "powell.jpg")
        self.imageView.backgroundColor = UIColor.yellowColor()
        
        //1010 specifies the overall width of the scroll view (which extends beyond the screen)
        self.scrollView.contentSize = CGSizeMake(1010, self.scrollView.frame.size.height)
        //scrollView.contentSize = CGSizeMake(scrollView.contentSize.width,scrollView.frame.size.height);

        //7 days in week
        //POPULATE the scrollview with tiles showing the day and hours open
        for i in 0..<7 {
            let day = self.library?.week[i] as dayInWeek!
            let name = day.name
            let open = day.open
            let close = day.close
            print(name)
            self.scrollView.addSubview(dayOfWeekAndHoursBox(frame: CGRect(origin: CGPoint(x:20+i*110, y:0), size: CGSize(width: 100, height: 100)), dayOfweek:name ,open:open, close:close))

        }
        
        

        //googleMaps
        
        let camera = GMSCameraPosition.cameraWithLatitude(30.1924699,
            longitude:-97.9016920, zoom:2)
       
        let mapView = GMSMapView.mapWithFrame(CGRect(x: 0, y: 0, width: 200, height: 200), camera:camera)
//        
//
//        
//        let marker = GMSMarker()
//        marker.position = camera.target
//        marker.snippet = "Hello World"
//        marker.appearAnimation = kGMSMarkerAnimationPop
//        marker.map = mapView

      //  libraryMap.addSubview(mapView)

        

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

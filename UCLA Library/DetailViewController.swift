//
//  DetailViewController.swift
//  UCLA Library
//
//  Created by Regan Hsu on 3/20/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var library: Library!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let library = self.library {
            if let name = library.name {
                self.nameLabel.text = name
            }
        }
        
        
        self.scrollView.contentSize = CGSizeMake(1100, 100)
        //7 days in week
        //POPULATE the day of week and hours of the scroll
        for i in 0..<7 {
            
            let day = self.library?.week[i] as dayInWeek!
            let name = day.name
            let open = day.open
            let close = day.close
            print(name)
            self.scrollView.addSubview(dayOfWeekAndHoursBox(frame: CGRect(origin: CGPoint(x:20+i*110, y:0), size: CGSize(width: 100, height: 100)), dayOfweek:name ,open:open, close:close))

        }

        // Do any additional setup after loading the view.
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

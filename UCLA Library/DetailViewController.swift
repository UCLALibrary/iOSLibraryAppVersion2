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
    
    var library: Library?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let library = self.library {
            if let name = library.name {
                self.nameLabel.text = name
            }
        }
        
        
        var center = CGPoint(x: 0, y: 50)
        var size = CGSize(width: 50, height: 50)
        var ugh = dayOfWeekAndHoursBox(frame: CGRect(origin: center, size: size))
        
    

        let count = 10
        for i in 0..<count {
            //sugh.center = CGPoint(x: 0 + i*50, y: 0)
            self.scrollView.addSubview(dayOfWeekAndHoursBox(frame: CGRect(origin: CGPoint(x:0+i*50, y:50), size: CGSize(width: 50, height: 50))))

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

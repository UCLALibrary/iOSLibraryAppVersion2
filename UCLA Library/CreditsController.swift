//
//  CreditsController.swift
//  UCLA Library
//
//  Created by Regan Hsu on 4/27/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit

class CreditsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseCredits(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
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

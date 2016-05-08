//
//  MenuController.swift
//  UCLA Library
//
//  Created by Regan Hsu on 4/16/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit

class MenuController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 27/255, green: 143/255, blue: 232/255, alpha: 0.9)
        //view.opaque = false
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidDisappear(animated: Bool) {
//        self.navigationController?.navigationBar.translucent = false
//    }
    
    
    //theese IBActions 'dismiss' the menu (translucent light blue modal) from the screen either from the x button of anywhere on the screen aside from the menu buttons
    @IBAction func dismissMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    
    }

    @IBAction func dismissMenu1(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func AskALibrarian(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://www.questionpoint.org/crs/qwidgetV4/patronChatQwidget.jsp?langcode=1&instid=11069&ts=1461524954773&skin=gray&size=standard&referer=http%3A%2F%2Fwww.library.ucla.edu%2Fsupport%2Fresearch-help")!)
    }
    
    @IBAction func MyAccount(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://catalog.library.ucla.edu/vwebv/login")!)
    }
    
    @IBAction func ResearchGuides(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://guides.library.ucla.edu/")!)
    }
    
    @IBAction func SearchCatalogues(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://catalog.library.ucla.edu/")!)
    }
    
    @IBAction func GoToFullSite(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://www.library.ucla.edu/")!)
    }
    
   
}

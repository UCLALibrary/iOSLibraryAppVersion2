//
//  MenuController.swift
//  UCLA Library
//
//  Created by Regan Hsu on 4/16/16.
//  Copyright © 2016 Regan Hsu. All rights reserved.
//

import UIKit
import SafariServices

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
    
    //theese IBActions 'dismiss' the menu (translucent light blue modal) from the screen either from the x button of anywhere on the screen aside from the menu buttons
    @IBAction func dismissMenu(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    
    }

    @IBAction func dismissMenu1(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func AskALibrarian(_ sender: AnyObject) {
        //UIApplication.sharedApplication().openURL(NSURL(string:"http://www.questionpoint.org/crs/qwidgetV4/patronChatQwidget.jsp?langcode=1&instid=11069&ts=1461524954773&skin=gray&size=standard&referer=http%3A%2F%2Fwww.library.ucla.edu%2Fsupport%2Fresearch-help")!)
        openURL("http://www.questionpoint.org/crs/qwidgetV4/patronChatQwidget.jsp?langcode=1&instid=11069&ts=1461524954773&skin=gray&size=standard&referer=http%3A%2F%2Fwww.library.ucla.edu%2Fsupport%2Fresearch-help")
    }
    
//    @IBAction func MyAccount(sender: AnyObject) {
//        UIApplication.sharedApplication().openURL(NSURL(string:"http://catalog.library.ucla.edu/vwebv/login")!)
//    }
    
    @IBAction func ResearchGuides(_ sender: AnyObject) {
        //UIApplication.sharedApplication().openURL(NSURL(string:"http://guides.library.ucla.edu/")!)
        openURL("http://guides.library.ucla.edu/")
    }
    
    @IBAction func SearchCatalogues(_ sender: AnyObject) {
        //UIApplication.sharedApplication().openURL(NSURL(string:"http://catalog.library.ucla.edu/")!)
        openURL("http://catalog.library.ucla.edu/")
    }
    
    @IBAction func GoToFullSite(_ sender: AnyObject) {
        //UIApplication.sharedApplication().openURL(NSURL(string:"https://www.library.ucla.edu/")!)
        openURL("https://www.library.ucla.edu/")
    }
    
    func openURL(_ urlString:String) {
    //TODO: Open in safari view controller
        let svc = SFSafariViewController(url: URL(string: urlString)!, entersReaderIfAvailable: true)
        self.present(svc, animated: true, completion: nil)
    }
    
   
}

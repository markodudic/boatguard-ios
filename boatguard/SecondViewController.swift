//
//  SecondViewController.swift
//  boatguard
//
//  Created by bl4z on 10/09/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblDashboard: UITableView!
    @IBOutlet var lblRefresh: UILabel!
    @IBOutlet var imgLogo: UIImageView!
    
    @IBOutlet var viewComponents: UIView!
    @IBOutlet var viewLogo: UIView!
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //add gradients
        tblDashboard.backgroundColor = UIColor.clearColor()

        let gl_top = CAGradientLayer()
        gl_top.colors = [settings.gradientTop, settings.gradientBottom]
        gl_top.locations = [0.0, 1.0]
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl_top.frame = CGRectMake(0,8,viewComponents.layer.frame.width,10)
        }
        else {
            gl_top.frame = CGRectMake(0,viewComponents.layer.frame.height,viewComponents.layer.frame.width,30)
            
        }
        viewComponents.layer.insertSublayer(gl_top, atIndex: 100)

        let gl_bottom = CAGradientLayer()
        gl_bottom.colors = [settings.gradientBottom, settings.gradientTop]
        gl_bottom.locations = [0.0, 1.0]
        if idiom == UIUserInterfaceIdiom.Phone {
            gl_bottom.frame = CGRectMake(0,viewComponents.layer.frame.height-21.5,viewComponents.layer.frame.width,10)
        }
        else {
            gl_bottom.frame = CGRectMake(0,viewComponents.layer.frame.height-30,viewComponents.layer.frame.width,30)
            
        }
        viewComponents.layer.insertSublayer(gl_bottom, atIndex: 100)

        let gll_bottom = CAGradientLayer()
        gll_bottom.colors = [settings.gradientTop, settings.gradientBottom]
        gll_bottom.locations = [0.0, 1.0]
        if idiom == UIUserInterfaceIdiom.Phone {
            gll_bottom.frame = CGRectMake(0,viewLogo.layer.frame.height-10,viewComponents.layer.frame.width,10)
        }
        else {
            gll_bottom.frame = CGRectMake(0,95,viewComponents.layer.frame.width,30)
            
        }
        viewLogo.layer.insertSublayer(gll_bottom, atIndex: 100)
        
        //show toolbar
        self.tabBarController?.tabBar.hidden = false
        
        //trigger data refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = settings.refresh
        
        var refreshing: NSMutableAttributedString = NSMutableAttributedString(string:  "R E F R E S H I N G")
        refreshing.addAttribute(NSForegroundColorAttributeName, value: settings.refresh, range: NSMakeRange(0, refreshing.length))
        self.refreshControl.attributedTitle = refreshing
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tblDashboard.addSubview(refreshControl)
        self.tblDashboard.delegate = self;
        
    
        refresh.setView(self) //send view to refresh
        refresh.addComponents() //add components to view
        //refresh.process()
        
        //refresh thread
        Async.background {
            while(true) {
                self.refreshData(self)
                sleep(settings.refreshTime)
                //states.setObudata(JSON.fromURL(settings.obudataUri+"?obuid="+String(states.getObuid())))
                //refresh.process()
           }
        }
        
    }
    
    //refresh via pull
    func refreshData(sender:AnyObject) {
        //fetch json
        states.setObudata(JSON.fromURL(settings.obudataUri+"?obuid="+String(states.getObuid())))
        refresh.process()
        
        self.lblRefresh.text = states.dblSpace("LAST UPDATE: "+states.getObudatadateTime())

        if (states.isAlarm) {
            imgLogo.image = UIImage(named: "logo_alarm")
        } else {
            imgLogo.image = UIImage(named: "logo")
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tblDashboard.reloadData() //force refresh even if not in focus
        })
        self.refreshControl.endRefreshing()
    }

    //first time & on tab open
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.getComponentsCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = components.getComponent(indexPath.row, tableView: tableView)
        cell.userInteractionEnabled = true
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var comps = components.getComponents()
        println(comps[indexPath.row].type);
        
        switch comps[indexPath.row].type {
            case "GEO":
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("GeoFenceView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            case "ANCHOR":
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AnchorView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            case "ACCU":
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("BatteryView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            case "PUMP":
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("BilgePumpView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            default: println()
        }
        
        
    }
}

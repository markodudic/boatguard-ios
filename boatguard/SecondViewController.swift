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
    var firstTime = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //add gradients
        tblDashboard.backgroundColor = UIColor.clearColor()

        let gl_top = CAGradientLayer()
        gl_top.colors = [settings.gradientTop, settings.gradientBottom]
        gl_top.locations = [0.0, 1.0]
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl_top.frame = CGRectMake(0,0,viewComponents.layer.frame.width,10)
        }
        else {
            gl_top.frame = CGRectMake(0,0,viewComponents.layer.frame.width,30)
            
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
            gll_bottom.frame = CGRectMake(0,viewLogo.layer.frame.height+7,viewComponents.layer.frame.width,30)
            
        }
        viewLogo.layer.insertSublayer(gll_bottom, atIndex: 100)
        
        //show toolbar
        self.tabBarController?.tabBar.hidden = false
        
        //trigger data refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = settings.refresh
        
        let refreshing: NSMutableAttributedString = NSMutableAttributedString(string:  "R E F R E S H I N G")
        var font = UIFont(name: "Dosis-Regular", size: 28)
        if idiom == UIUserInterfaceIdiom.Phone {
            font = UIFont(name: "Dosis-Regular", size: 14)
        }
        refreshing.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, refreshing.length))
        refreshing.addAttribute(NSForegroundColorAttributeName, value: settings.refresh, range: NSMakeRange(0, refreshing.length))
        self.refreshControl.attributedTitle = refreshing
        self.refreshControl.addTarget(self, action: "refreshDataManualy:", forControlEvents: UIControlEvents.ValueChanged)
       
        self.tblDashboard.addSubview(refreshControl)
        self.tblDashboard.delegate = self;
    
        refresh.setView1(self) //send view to refresh
        refresh.addComponents() //add components to view
        //refresh.process()
        
        //refresh thread
        Async.background {
            while(true) {
                self.refreshData(self, manually:false)
                sleep(settings.refreshTime)
           }
        }
        
    }
    
    //refresh via pull
    func refreshDataManualy(sender:AnyObject) {
        Flurry.logEvent("Refresh Manually")
        self.refreshData(self, manually:true)
    }
    
    func refreshData(sender:AnyObject, manually:Bool) {
        //fetch json
        var dataChanged = true;
        
        let json = Comm.JSONfromURL(settings.obudataUri+"?obuid="+String(states.getObuid()))
        
        if (json["error"].isDictionary){
            if (manually == true) {
                let alert = UIAlertController(title: json["error"]["name"].asString, message: json["error"]["msg"].asString, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        else {
            dataChanged = (states.getObudata().description != json.description);
            states.setObudata(json)
        }
        
        if (dataChanged || firstTime) {
            refresh.process()
            firstTime = false
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.lblRefresh.attributedText = NSAttributedString(string: "LAST UPDATE: "+states.getObudatadateTime(), attributes: [NSKernAttributeName:3])
        } else {
            self.lblRefresh.attributedText = NSAttributedString(string: "LAST UPDATE: "+states.getObudatadateTime(), attributes: [NSKernAttributeName:4])
        }
        
        //self.lblRefresh.text = states.dblSpace("LAST UPDATE: "+states.getObudatadateTime())
            
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
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tblDashboard.reloadData() //force refresh even if not in focus
        })
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
        
        switch comps[indexPath.row].type {
            case "GEO":
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("GeoFenceView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case "ANCHOR":
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AnchorView")
                self.presentViewController(vc, animated: false, completion: nil)
            case "ACCU":
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("BatteryView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case "PUMP":
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("BilgePumpView") 
                self.presentViewController(vc, animated: false, completion: nil)
            default: print("")
        }
        
        
    }
}

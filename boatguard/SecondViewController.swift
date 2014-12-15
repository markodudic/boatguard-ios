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
        gl_top.frame = CGRectMake(0,0,320,10)
        viewComponents.layer.insertSublayer(gl_top, atIndex: 0)

        let gl_bottom = CAGradientLayer()
        gl_bottom.colors = [settings.gradientBottom, settings.gradientTop]
        gl_bottom.locations = [0.0, 1.0]
        gl_bottom.frame = CGRectMake(0,viewComponents.layer.frame.height-10,320,10)
        viewComponents.layer.insertSublayer(gl_bottom, atIndex: 0)

        let gll_bottom = CAGradientLayer()
        gll_bottom.colors = [settings.gradientBottom, settings.gradientTop]
        gll_bottom.locations = [0.0, 1.0]
        gll_bottom.frame = CGRectMake(0,viewLogo.layer.frame.height-10,320,10)
        viewLogo.layer.insertSublayer(gll_bottom, atIndex: 0)
        
        //show toolbar
        self.tabBarController?.tabBar.hidden = false
        
        //trigger data refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "refreshing data")
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tblDashboard.addSubview(refreshControl)
    }
    
    //refresh via pull
    func refreshData(sender:AnyObject) {
        //fetch json
        states.setObudata(JSON.fromURL(settings.obudataUri+"?obuid="+String(states.getObuid())))
        self.lblRefresh.text = states.dblSpace("LAST UPDATE: "+states.getObudatadateTime())
        refresh.process()
        if (states.isAlarm) {
            imgLogo.image = UIImage(named: "logo_alarm")
        } else {
            imgLogo.image = UIImage(named: "logo")
        }
        tblDashboard.reloadData() //force refresh
        self.refreshControl.endRefreshing()
    }

    //first time & on tab open
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        //show toolbar
        self.tabBarController?.tabBar.hidden = false
        self.lblRefresh.text = states.dblSpace("LAST UPDATE: "+states.getObudatadateTime())
        
        if (states.isAlarm) {
            imgLogo.image = UIImage(named: "logo_alarm")
        } else {
            imgLogo.image = UIImage(named: "logo")
        }

        //refresh component alarms
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tblDashboard.reloadData() //force refresh even if not in focus
        })
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
        return cell
    }
}

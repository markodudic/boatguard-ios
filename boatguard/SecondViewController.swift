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
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //trigger data refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "refreshing data")
        self.refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.tblDashboard.addSubview(refreshControl)
    }
    
    //refresh via pull
    func refreshData(sender:AnyObject) {
        states.setObudata(JSON.fromURL(settings.obudataUri+"?obuid="+String(states.getObuid())))
        self.lblRefresh.text = "LAST UPDATE: "+states.getObudatadateTime()
        refresh.process()
        if (states.isAlarm) {
            imgLogo.image = UIImage(named: "logo_alarm")
        } else {
            imgLogo.image = UIImage(named: "logo")
        }
        self.refreshControl.endRefreshing()
    }

    //first time & on tab open
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.lblRefresh.text = "LAST UPDATE: "+states.getObudatadateTime()
        
        if (states.isAlarm) {
            imgLogo.image = UIImage(named: "logo_alarm")
        } else {
            imgLogo.image = UIImage(named: "logo")
        }
    }
    
    func onCellAnimation(cell: UITableViewCell) {
        UIView.animateWithDuration(2, animations: {
            cell.backgroundColor = UIColor(red: CGFloat(0.753), green: CGFloat(0.255), blue: CGFloat(0.106), alpha: CGFloat(1))
            }, completion: {
                (value: Bool) in
                self.offCellAnimation(cell)
        })
    }
    
    func offCellAnimation(cell: UITableViewCell) {
        UIView.animateWithDuration(2, animations: {
            cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.886), blue: CGFloat(0.886), alpha: CGFloat(1))
            }, completion: {
                (value: Bool) in
                self.onCellAnimation(cell)
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
        let comp = components.getComponent(indexPath.row)
        if (comp.alarm) {
            self.onCellAnimation(comp.cell)
        }
        return comp.cell
    }
}
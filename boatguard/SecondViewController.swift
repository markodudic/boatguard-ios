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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblRefresh.text = "LAST UPDATE: "+states.getObudatadateTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var json = states.getObucomponents()
        return json.length
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")

        var json = states.getObucomponents()
        
        cell.textLabel?.text = json[indexPath.row]["name"].asString
        cell.detailTextLabel?.text = "data" //json_states[indexPath.row]["value"].asString
        cell.imageView?.image = UIImage(named: "ic_marker")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        
        return cell
    }
}


//
//  PhoneContactsViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 6/3/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class PhoneContactsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var viewContacts: UIView!
    @IBOutlet var tableView: UITableView!
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("Phone contacts Settings")
        //add gradients
        let gl = CAGradientLayer()
        gl.colors = [settings.gradientTop, settings.gradientBottom]
        gl.locations = [0.0, 1.0]
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewContacts.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewContacts.layer.frame.width,30)
            
        }
        viewContacts.layer.insertSublayer(gl, atIndex: 999)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return states.friends.length;
    }
    
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsCell") as ContactsCell
        var friend = states.friends[indexPath.row]
        cell.lblName.text = friend["name"].asString! + " " + friend["surname"].asString!
        if (friend["email"].isNull || friend["email"].asString? == "null") {
            cell.lblDetail.text = friend["number"].asString!
        }
        else {
            cell.lblDetail.text = friend["number"].asString! + " / " + friend["email"].asString!
        }
        cell.img.hidden = true
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        println(indexPath.row)
    }
}

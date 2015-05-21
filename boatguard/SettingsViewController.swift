//
//  SettingsViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 3/18/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var viewSettings: UIView!
    @IBOutlet var tableView: UITableView!
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("Settings")
        //add gradients
        let gl = CAGradientLayer()
        gl.colors = [settings.gradientTop, settings.gradientBottom]
        gl.locations = [0.0, 1.0]
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewSettings.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewSettings.layer.frame.width,30)
            
        }
        viewSettings.layer.insertSublayer(gl, atIndex: 999)
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return settings.settingsTableData.count;
    }
    
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as SettingsCell
        cell.lbl.text = settings.settingsTableData[indexPath.row]
        cell.lblState.text = ""
        cell.lblState.textColor = settings.lblGreen
        switch indexPath.row {
            case 0:
                cell.lblState.text = states.getObuSettingsByIdState(32)["value"].asString! + "Ah / " +
                                     states.getObuSettingsByIdState(33)["value"].asString! + "%"
            case 1:
                if (states.getObuSettingsByIdState(10)["value"].asString! == "1") {
                    cell.lblState.text = "ON"
                }
                else {
                    cell.lblState.text = "OFF"
                    cell.lblState.textColor = settings.lblRed
                }
            case 2:
                if (states.getObuSettingsByIdState(40)["value"].asString! == "1") {
                    cell.lblState.text = "ON"
                }
                else {
                    cell.lblState.text = "OFF"
                    cell.lblState.textColor = settings.lblRed
                }
            case 3:
                if (states.getObuSettingsByIdState(22)["value"].asString! == "1") {
                    cell.lblState.text = "ON"
                }
                else {
                    cell.lblState.text = "OFF"
                }
                cell.lblState.text = cell.lblState.text! + " / " +
                                    states.getObuSettingsByIdState(23)["value"].asString! + " / " +
                                    states.getObuSettingsByIdState(24)["value"].asString!
            case 6:
                cell.lblState.text = states.customer["name"].asString! + " " + states.customer["surname"].asString! + " / " +
                    states.customer["boat_name"].asString!
            case 8:
                cell.lblState.text = states.getObuSettingsByIdState(1)["value"].asString!
            default: println()
        }
       
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        switch indexPath.row {
            case 0:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("BatteryView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            case 1:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("GeoFenceView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            case 2:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AnchorView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            case 3:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("BilgePumpView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            case 6:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MyAccountView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            case 7:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("HistoryView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            case 8:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AppSettingsView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            case 9:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FirstView") as UIViewController
                self.presentViewController(vc, animated: false, completion: nil)
            default: println()
        }

    }
}
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
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as! SettingsCell
        cell.lbl.attributedText = NSAttributedString(string: settings.settingsTableData[indexPath.row], attributes: [NSKernAttributeName:4])
        //cell.lbl.text = settings.settingsTableData[indexPath.row]
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
            case 4:
                var contacts = "";
                for (i, v) in states.friends {
                    if !contacts.isEmpty {
                        contacts += " / ";
                    }
                    contacts += v["name"].asString! + " " + v["surname"].asString!
                }
                cell.lblState.text = contacts
            case 5:
                let playSound = NSUserDefaults.standardUserDefaults().boolForKey("SETTING_PLAY_SOUND")
                let vibrate = NSUserDefaults.standardUserDefaults().boolForKey("SETTING_VIBRATE")
                let popUp = NSUserDefaults.standardUserDefaults().boolForKey("SETTING_POP_UP")
                var settings = ""
                if playSound {
                    settings += "PLAY SOUND"
                }
                if playSound&&vibrate {
                    settings += " / "
                }
                if vibrate {
                    settings += "VIBRATE"
                }
                if ((playSound && !vibrate) || vibrate) && popUp {
                    settings += " / "
                }
                if popUp {
                    settings += "POP-UP"
                }
                cell.lblState.text = settings
            case 6:
                var name = "";
                if (states.customer["name"].asString != nil) {
                    name = states.customer["name"].asString!
                }
                var surname = "";
                if (states.customer["surname"].asString != nil) {
                    surname = states.customer["surname"].asString!
                }
                var boat_name = "";
                if (states.customer["boat_name"].asString != nil) {
                    boat_name = states.customer["boat_name"].asString!
                }
                cell.lblState.text = name + " " + surname + " / " + boat_name
            case 8:
                cell.lblState.text = states.getObuSettingsByIdState(1)["value"].asString!
            default: print("")
        }
       
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        switch indexPath.row {
            case 0:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("BatteryView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case 1:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("GeoFenceView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case 2:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AnchorView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case 3:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("BilgePumpView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case 4:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AlarmContactsView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case 5:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AlarmSettingsView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case 6:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MyAccountView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case 7:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("HistoryView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case 8:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AppSettingsView") 
                self.presentViewController(vc, animated: false, completion: nil)
            case 9:
                let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FirstView") 
                self.presentViewController(vc, animated: false, completion: nil)
            default: print("")
        }

    }
}
//
//  AlarmSettingsViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 6/3/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class AlarmSettingsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {
    
    @IBOutlet var viewAlarmSettings: UIView!
    @IBOutlet var swPlaySound: UISwitch!
    @IBOutlet var swVibrate: UISwitch!
    @IBOutlet var swPopUp: UISwitch!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("Alarm settings Settings")
        //add gradients
        let gl = CAGradientLayer()
        gl.colors = [settings.gradientTop, settings.gradientBottom]
        gl.locations = [0.0, 1.0]
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewAlarmSettings.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewAlarmSettings.layer.frame.width,30)
            
        }
        viewAlarmSettings.layer.insertSublayer(gl, atIndex: 999)
        
        swPlaySound.on = NSUserDefaults.standardUserDefaults().boolForKey("SETTING_PLAY_SOUND")
        swVibrate.on = NSUserDefaults.standardUserDefaults().boolForKey("SETTING_VIBRATE")
        swPopUp.on = NSUserDefaults.standardUserDefaults().boolForKey("SETTING_POP_UP")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func swPlaySound_valueChanged(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "SETTING_PLAY_SOUND")
    }
    
    @IBAction func swVibrate_valueChanged(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "SETTING_VIBRATE")
    }
    
    @IBAction func swPopUp_valueChanged(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "SETTING_POP_UP")
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return states.alarms.length;
    }
    
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlarmCell") as! AlarmCell
        var alarm = states.alarms[indexPath.row]
        cell.lblAlarmName.text = alarm["message_short"].asString!.uppercaseString
        
        cell.swAlarmOn.on = alarm["active"].asInt! == 1
        cell.swSendEmail.on = alarm["send_email"].asInt! == 1
        cell.swAlarmFriends.on = alarm["send_friends"].asInt! == 1

        cell.swChanged(alarm["id_alarm"].asInt!)
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
    }
}



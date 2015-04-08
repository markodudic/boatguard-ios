//
//  BatteryViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 4/2/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//


import UIKit

class BatteryViewController: UIViewController {
    
    @IBOutlet var txtCapacity: UITextField!
    @IBOutlet var viewBattery: UIView!
    @IBOutlet var slBatteryAlarm: UISlider!
    @IBOutlet var lblAlarm: UILabel!
    
    var obusettings:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add gradients
        let gl = CAGradientLayer()
        gl.colors = [settings.gradientTop, settings.gradientBottom]
        gl.locations = [0.0, 1.0]
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewBattery.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewBattery.layer.frame.width,30)
            
        }
        viewBattery.layer.insertSublayer(gl, atIndex: 999)
        
        txtCapacity.text = states.getObuSettingsByIdState(32)["value"].asString! + "Ah"
        lblAlarm.text = states.getObuSettingsByIdState(33)["value"].asString! + "%"
        slBatteryAlarm.value = (states.getObuSettingsByIdState(33)["value"].asString! as NSString).floatValue
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
        states.setObuSetting(32, value: txtCapacity.text.stringByReplacingOccurrencesOfString("Ah", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
        Comm.HTTPPostJSON(settings.obusettingsSetUri, jsonObj: states.getObusettings().toString(pretty: false))
    }
    
    @IBAction func btnReset_click(sender: UIButton) {
        states.setObuSetting(31, value: "1")
    }
    
    @IBAction func slBatteryAlarm_valueChanged(sender: UISlider) {
        var alarm = Int(sender.value)
        lblAlarm.text = "\(alarm)%"
    }
    
    @IBAction func slBatteryAlarm_finished(sender: UISlider) {
        var alarm = Int(sender.value)
        states.setObuSetting(33, value: String(alarm))
    }

    
}



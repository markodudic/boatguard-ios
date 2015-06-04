//
//  AlarmSettingsViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 6/3/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class AlarmSettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var viewAlarmSettings: UIView!
    @IBOutlet var swAlarmSettings: UISwitch!
    
    var obusettings:JSON!
    
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
        
        swAlarmSettings.on = (states.getObuSettingsByIdState(22)["value"].asString! == "1")

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func swAlarmSettings_valueChanged(sender: UISwitch) {
        var vl = 0
        if (sender.on) {
            vl = 1
        }
        states.setObuSetting(22, value: String(vl))
    }
    


    
}



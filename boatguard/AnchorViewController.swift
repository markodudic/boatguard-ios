//
//  AnchorViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 4/1/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//


import UIKit

class AnchorViewController: UIViewController {
    
    @IBOutlet var viewAnchor: UIView!
    @IBOutlet var swAnchor: UISwitch!
    @IBOutlet var slAnchorDistance: UISlider!
    @IBOutlet var lblDistance: UILabel!
    
    var obusettings:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("Anchor Settings")
        //add gradients
        let gl = CAGradientLayer()
        gl.colors = [settings.gradientTop, settings.gradientBottom]
        gl.locations = [0.0, 1.0]
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewAnchor.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewAnchor.layer.frame.width,30)
            
        }
        viewAnchor.layer.insertSublayer(gl, atIndex: 999)
        
        swAnchor.on = (states.getObuSettingsByIdState(40)["value"].asString! == "1")
        lblDistance.text = states.getObuSettingsByIdState(41)["value"].asString! + "m"
        slAnchorDistance.value = (states.getObuSettingsByIdState(41)["value"].asString! as NSString).floatValue
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
        Comm.HTTPPostJSON(settings.obusettingsSetUri, jsonObj: states.getObusettings().toString(false))
    }
    
    @IBAction func btnDefine_click(sender: UIButton) {
        Flurry.logEvent("Anchor Define")
        states.setObuSetting(11, value: "SET")
        Comm.HTTPPostJSON(settings.obusettingsSetUri, jsonObj: states.getObusettings().toString(false))
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func slAnchorDistance_valueChanged(sender: UISlider) {
        let dist = Int(sender.value)
        lblDistance.text = "\(dist)m"
    }
    
    @IBAction func slAnchorDistance_finished(sender: UISlider) {
        let dist = Int(sender.value)
        states.setObuSetting(41, value: String(dist))
    }
    
    @IBAction func swAnchor_valueChanged(sender: UISwitch) {
        Flurry.logEvent("Anchor On/Off")
        var vl = 0
        if (sender.on) {
            vl = 1
        }
        states.setObuSetting(40, value: String(vl))
    }
    
}


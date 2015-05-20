//
//  GeoFenceController.swift
//  boatguard
//
//  Created by Marko Dudic on 3/20/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class GeoFenceViewController: UIViewController {
    
    @IBOutlet var viewGeoFence: UIView!
    @IBOutlet var swGeoFence: UISwitch!
    @IBOutlet var slGeoFenceDistance: UISlider!
    @IBOutlet var lblDistance: UILabel!
    
    var obusettings:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("GeoFence Settings")
        //add gradients
        let gl = CAGradientLayer()
        gl.colors = [settings.gradientTop, settings.gradientBottom]
        gl.locations = [0.0, 1.0]
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewGeoFence.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewGeoFence.layer.frame.width,30)
            
        }
        viewGeoFence.layer.insertSublayer(gl, atIndex: 999)
        
        swGeoFence.on = (states.getObuSettingsByIdState(10)["value"].asString! == "1")
        lblDistance.text = states.getObuSettingsByIdState(13)["value"].asString! + "m"
        slGeoFenceDistance.value = (states.getObuSettingsByIdState(13)["value"].asString! as NSString).floatValue
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
        Comm.HTTPPostJSON(settings.obusettingsSetUri, jsonObj: states.getObusettings().toString(pretty: false))
    }
    
    @IBAction func btnDefine_click(sender: UIButton) {
        Flurry.logEvent("GeoFence Define")
        states.setObuSetting(11, value: "SET")
        Comm.HTTPPostJSON(settings.obusettingsSetUri, jsonObj: states.getObusettings().toString(pretty: false))
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func slGeoFenceDistance_valueChanged(sender: UISlider) {
        var dist = Int(sender.value)
        lblDistance.text = "\(dist)m"
    }
    
    @IBAction func slGeoFenceDistance_finished(sender: UISlider) {
        var dist = Int(sender.value)
        states.setObuSetting(13, value: String(dist))
    }
    
    @IBAction func swGeoFence_valueChanged(sender: UISwitch) {
        Flurry.logEvent("GeoFence On/Off")
        var vl = 0
        if (sender.on) {
            vl = 1
        }
        states.setObuSetting(10, value: String(vl))
    }

}

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
        
        obusettings = states.getObusettings()
        for (i, v) in obusettings {
            if (v["id_setting"].asInt == 10) {
                swGeoFence.on = (v["value"].asString! == "1")
            }
            else if (v["id_setting"].asInt == 13) {
                lblDistance.text = v["value"].asString! + "m"
                slGeoFenceDistance.value = (v["value"].asString! as NSString).floatValue
            }
        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
        states.HTTPPostJSON(settings.obusettingsSetUri, jsonObj: states.getObusettings().toString(pretty: false))
    }
    
    @IBAction func btnDefine_click(sender: UIButton) {
        states.setObuSetting(11, code: "LAT", value: "SET")
        states.HTTPPostJSON(settings.obusettingsSetUri, jsonObj: states.getObusettings().toString(pretty: false))
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func slGeoFenceDistance_valueChanged(sender: UISlider) {
        var dist = Int(sender.value)
        lblDistance.text = "\(dist)m"
    }
    
    @IBAction func slGeoFenceDistance_finished(sender: UISlider) {
        var dist = Int(sender.value)
        states.setObuSetting(13, code: "GEO_FENCE_DISTANCE", value: String(dist))
    }
    
    @IBAction func swGeoFence_valueChanged(sender: UISwitch) {
        var vl = 0
        if (sender.on) {
            vl = 1
        }
        states.setObuSetting(10, code: "GEO_FENCE", value: String(vl))
    }

}

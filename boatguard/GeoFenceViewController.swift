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
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
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
    
    @IBAction func btnDefine_click(sender: UIButton) {
        let obusettingsSetUri = settings.obusettingsSetUri+"?json="+obusettings.toString(pretty: false)
        println(obusettingsSetUri);
        var obusettingsSetJSON       = JSON.fromURL(obusettingsSetUri)
        println(obusettingsSetJSON);
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func slGeoFenceDistance_valueChanged(sender: UISlider) {
        var dist = Int(sender.value)
        lblDistance.text = "\(dist)m"
    }
    
    @IBAction func slGeoFenceDistance_finished(sender: UISlider) {
        var dist = Int(sender.value)
        var obusettingsNew = ""
        var first = true
        
        for (i, v) in obusettings {
            var vs = v.toString(pretty: false);
            if (v["id_setting"].asInt == 13) {
                var vl = v["value"]
                let vsnew: [String:AnyObject] = ["id_setting" : v["id_setting"],
                                                "code" : "GEO_FENCE_DISTANCE",
                                                "type" : "",
                                                "value" : "\(dist)",
                                                "id_obu" : states.getObuid()]
                vs = JSON(vsnew).toString()
            }
            if (first) {
                obusettingsNew = obusettingsNew + vs;
                first = false
            }
            else {
                obusettingsNew = obusettingsNew + "," + vs;
            }
        }
        obusettingsNew = "[" + obusettingsNew + "]";
        var j = JSON(string: obusettingsNew)
        states.setObusettings(j)

    }
    
    @IBAction func swGeoFence_valueChanged(sender: UISwitch) {
        var obusettingsNew = ""
        var first = true

        for (i, v) in obusettings {
            var vs = v.toString(pretty: false);
            if (v["id_setting"].asInt == 10) {
                var vl = 0
                if (sender.on) {
                   vl = 1
                }
                let vsnew: [String:AnyObject] = ["id_setting" : v["id_setting"],
                                                "code" : "GEO_FENCE",
                                                "type" : "",
                                                "value" : "\(vl)",
                                                "id_obu" : states.getObuid()]
                vs = JSON(vsnew).toString()
            }
            if (first) {
                obusettingsNew = obusettingsNew + vs;
                first = false
            }
            else {
                obusettingsNew = obusettingsNew + "," + vs;
            }
        }
        obusettingsNew = "[" + obusettingsNew + "]";
        var j = JSON(string: obusettingsNew)
        states.setObusettings(j)
    }

}

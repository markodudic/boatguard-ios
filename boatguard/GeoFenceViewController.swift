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
        println(obusettings);
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

        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func slGeoFenceDistance_valueChanged(sender: UISlider) {
        var dist = Int(sender.value)
        lblDistance.text = "\(dist)m"
        var obusettingsNew:JSON!
        
        for (i, var v: JSON) in obusettings {
            if (v["id_setting"].asInt == 13) {
                var vl = v["value"]
                vl = JSON("\(dist)")
                println(vl);
                //v = JSON(vl)
                //states.setObusettings(v)
            }
        }
        
        /*var json: JSON = ["foo": ["amount": 2], "bar": ["amount": 3]]
        for (key, var item: JSON) in json {
            println("\(key) -> \(item)")
            item["price"] = 10
            json[key] = item
        }
        println(json)*/
    }
    
    @IBAction func swGeoFence_valueChanged(sender: UISwitch) {
        for (i, var v: JSON) in obusettings {
            if (v["id_setting"].asInt == 10) {
                var vl = v["value"]
                if (swGeoFence.on) {
                    vl = JSON("1")
                }
                else {
                    vl = JSON("0")
                }
                //obusettings[i] = v
            }
        }
    }
}

//
//  BilgePumpViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 4/2/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class BilgePumpViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var viewBilgePump: UIView!
    @IBOutlet var swBilgePump: UISwitch!
    
    @IBOutlet var pvShortPeriod: UIPickerView! = UIPickerView()
    @IBOutlet var tfShortPeriod: UITextField! = nil
    @IBOutlet var pvLongPeriod: UIPickerView! = UIPickerView()
    @IBOutlet var tfLongPeriod: UITextField! = nil
    let short = ["1", "2", "5", "10"]
    let long = ["5", "10", "30", "60"]
    
    var obusettings:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("Bilge Pump Settings")
        //add gradients
        let gl = CAGradientLayer()
        gl.colors = [settings.gradientTop, settings.gradientBottom]
        gl.locations = [0.0, 1.0]
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewBilgePump.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewBilgePump.layer.frame.width,30)
            
        }
        viewBilgePump.layer.insertSublayer(gl, atIndex: 999)
        
        swBilgePump.on = (states.getObuSettingsByIdState(22)["value"].asString! == "1")
        tfShortPeriod.text = states.getObuSettingsByIdState(23)["value"].asString!
        tfLongPeriod.text = states.getObuSettingsByIdState(24)["value"].asString!
        
        tfShortPeriod.delegate = self
        tfShortPeriod.inputView = pvShortPeriod
        pvShortPeriod.hidden = true
        pvShortPeriod.delegate = self
        
        tfLongPeriod.delegate = self
        tfLongPeriod.inputView = pvLongPeriod
        pvLongPeriod.hidden = true
        pvLongPeriod.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
        states.setObuSetting(23, value: String(tfShortPeriod.text))
        states.setObuSetting(24, value: String(tfLongPeriod.text))
        Comm.HTTPPostJSON(settings.obusettingsSetUri, jsonObj: states.getObusettings().toString(false)) 
    }
    
    @IBAction func swBilgePump_valueChanged(sender: UISwitch) {
        var vl = 0
        if (sender.on) {
            vl = 1
        }
        states.setObuSetting(22, value: String(vl))
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == tfShortPeriod {
            pvShortPeriod.hidden = false
        }
        else {
            pvLongPeriod.hidden = false
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == tfShortPeriod {
            resignFirstResponder()
            pvShortPeriod.hidden = true
        }
        else {
            resignFirstResponder()
            pvLongPeriod.hidden = true
        }
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return short.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == pvShortPeriod {
            return short[row]
        }
        else {
            return long[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pvShortPeriod {
            tfShortPeriod.text = "\(short[row])"
        }
        else {
            tfLongPeriod.text = "\(long[row])"
        }
    }
    
}


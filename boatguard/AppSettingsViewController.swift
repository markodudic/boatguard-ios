//
//  AppSettingsViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 4/9/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var viewAppSettings: UIView!
    @IBOutlet var pvTime: UIPickerView! = UIPickerView()
    @IBOutlet var tfTime: UITextField! = nil
    @IBOutlet var lblVersion: UILabel!
    
    let time = ["05", "10", "15", "30", "59"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("GeoFence")
        //add gradients
        let gl = CAGradientLayer()
        gl.colors = [settings.gradientTop, settings.gradientBottom]
        gl.locations = [0.0, 1.0]
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewAppSettings.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewAppSettings.layer.frame.width,30)
            
        }
        viewAppSettings.layer.insertSublayer(gl, atIndex: 999)
        
        tfTime.text = states.getObuSettingsByIdState(1)["value"].asString!
        
        tfTime.delegate = self
        tfTime.inputView = pvTime
        pvTime.hidden = true
        pvTime.delegate = self
        
        lblVersion.text = (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as String) + " (" + (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as String) + ")"

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
        states.setObuSetting(1, value: String(tfTime.text))
        Comm.HTTPPostJSON(settings.obusettingsSetUri, jsonObj: states.getObusettings().toString(pretty: false))
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        pvTime.hidden = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        resignFirstResponder()
        pvTime.hidden = true
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return time.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return time[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        tfTime.text = "\(time[row])"
    }
}

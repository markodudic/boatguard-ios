//
//  MyAccountViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 5/20/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, NSURLConnectionDelegate {
    
    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var txtPassConfirm: UITextField!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtSurname: UITextField!
    @IBOutlet var pvBirthYear: UIPickerView! = UIPickerView()
    @IBOutlet var txtBirthYear: UITextField! = nil
    @IBOutlet var pvCountry: UIPickerView! = UIPickerView()
    @IBOutlet var txtCountry: UITextField! = nil
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtBoatName: UITextField!
    @IBOutlet var pvBoatManafacturer: UIPickerView! = UIPickerView()
    @IBOutlet var txtBoatManafacturer: UITextField! = nil
    @IBOutlet var pvBoatModel: UIPickerView! = UIPickerView()
    @IBOutlet var txtBoatModel: UITextField! = nil
    @IBOutlet var pvBoatCountry: UIPickerView! = UIPickerView()
    @IBOutlet var txtBoatCountry: UITextField! = nil
    @IBOutlet var txtObuid: UITextField!
 
    let year = ["1945","1946","1947","1948","1949","1950","1951","1952","1953","1954","1955",]
    let country = ["Austria","Croatia","France","Germany","Great Britain","Greece","Holland","Italy","Slovenia","Spain","Sweden","Other"]
    let manafacturer = ["Janno","Bavaria","SAS","Elan","Other"]
    let model = ["SeaScape 19","SeaScape 28","Odissez 39","Elan 45","Other"]
    
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var viewLoginTitle: UIView!
    @IBOutlet var viewDashboardTitle: UIView!
    @IBOutlet var viewDashboard: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add gradients
        let gl_login = CAGradientLayer()
        gl_login.colors = [settings.gradientTop, settings.gradientBottom]
        gl_login.locations = [0.0, 1.0]
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl_login.frame = CGRectMake(0,0,scrollView.layer.frame.width,10)
        }
        else {
            gl_login.frame = CGRectMake(0,0,scrollView.layer.frame.width,30)
            
        }
        scrollView.layer.insertSublayer(gl_login, atIndex: 0)
        
        txtUser.text = states.getUser()
        txtPass.text = states.getPass()
        txtPassConfirm.text = states.getPass()
        if states.customer["name"].asString != nil {
            txtName.text = states.customer["name"].asString!
        }
        if states.customer["surname"].asString != nil {
            txtSurname.text = states.customer["surname"].asString!
        }
        var b = states.customer["birth_year"].asInt
        if b != nil && b != 0 {
            txtBirthYear.text = String(b!)
        }
        if states.customer["country"].asString != nil {
            txtCountry.text = states.customer["country"].asString!
        }
        if states.customer["email"].asString != nil {
            txtEmail.text = states.customer["email"].asString!
        }
        if states.customer["boat_name"].asString != nil {
            txtBoatName.text = states.customer["boat_name"].asString!
        }
        if states.customer["boat_manafacturer"].asString != nil {
            txtBoatManafacturer.text = states.customer["boat_manafacturer"].asString!
        }
        if states.customer["boat_model"].asString != nil {
            txtBoatModel.text = states.customer["boat_model"].asString!
        }
        if states.customer["boat_country"].asString != nil {
            txtBoatCountry.text = states.customer["boat_country"].asString!
        }
        txtObuid.text = states.customer["serial_number"].asString!
        
        txtBirthYear.delegate = self
        txtBirthYear.inputView = pvBirthYear
        pvBirthYear.hidden = true
        pvBirthYear.delegate = self
        
        txtCountry.delegate = self
        txtCountry.inputView = pvCountry
        pvCountry.hidden = true
        pvCountry.delegate = self
        
        txtBoatManafacturer.delegate = self
        txtBoatManafacturer.inputView = pvBoatManafacturer
        pvBoatManafacturer.hidden = true
        pvBoatManafacturer.delegate = self
        
        txtBoatModel.delegate = self
        txtBoatModel.inputView = pvBoatModel
        pvBoatModel.hidden = true
        pvBoatModel.delegate = self
        
        txtBoatCountry.delegate = self
        txtBoatCountry.inputView = pvBoatCountry
        pvBoatCountry.hidden = true
        pvBoatCountry.delegate = self
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            scrollView.contentSize = CGSize(width:100, height:1300)
        }
        else {
            scrollView.contentSize = CGSize(width:100, height:2400)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    //Events
    @IBAction func btnCancel_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)

    }
    
    @IBAction func btnOk_click(sender: UIButton) {
        if txtPass.text != txtPassConfirm.text {
            var alert = UIAlertController(title: "Password", message: "Password and confirm password are not equal", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            self.dismissViewControllerAnimated(false, completion: nil)
            states.setCustomerSetting(txtName.text, surname: txtSurname.text, password: txtPass.text, birthYear: txtBirthYear.text, country: txtCountry.text, email: txtEmail.text, boatName: txtBoatName.text, boatManafacturer: txtBoatManafacturer.text, boatModel: txtBoatModel.text, boatCountry: txtBoatCountry.text)
            Comm.HTTPPostJSON(settings.customerSetUri, jsonObj: states.customer.toString(pretty: false))
        }
    }


    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tole je za skrivanje tipkovnice ob prijavi
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == txtBirthYear {
            pvBirthYear.hidden = false
        }
        else if textField == txtCountry {
            pvCountry.hidden = false
        }
        else if textField == txtBoatManafacturer {
            pvBoatManafacturer.hidden = false
        }
        else if textField == txtBoatModel {
            pvBoatModel.hidden = false
        }
        else if textField == txtBoatCountry {
            pvBoatCountry.hidden = false
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        resignFirstResponder()
        if textField == txtBirthYear {
            pvBirthYear.hidden = true
        }
        else if textField == txtCountry {
            pvCountry.hidden = true
        }
        else if textField == txtBoatManafacturer {
            pvBoatManafacturer.hidden = true
        }
        else if textField == txtBoatModel {
            pvBoatModel.hidden = true
        }
        else if textField == txtBoatCountry {
            pvBoatCountry.hidden = true
        }
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == pvBirthYear {
            return year.count
        }
        else if pickerView == pvCountry {
            return country.count
        }
        else if pickerView == pvBoatManafacturer {
            return manafacturer.count
        }
        else if pickerView == pvBoatModel {
            return model.count
        }
        else if pickerView == pvBoatCountry {
            return country.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == pvBirthYear {
           return year[row]
        }
        else if pickerView == pvCountry {
            return country[row]
        }
        else if pickerView == pvBoatManafacturer {
            return manafacturer[row]
        }
        else if pickerView == pvBoatModel {
            return model[row]
        }
        else if pickerView == pvBoatCountry {
            return country[row]
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pvBirthYear {
            txtBirthYear.text = "\(year[row])"
        }
        else if pickerView == pvCountry {
            txtCountry.text = "\(country[row])"
        }
        else if pickerView == pvBoatManafacturer {
            txtBoatManafacturer.text = "\(manafacturer[row])"
        }
        else if pickerView == pvBoatModel {
            txtBoatModel.text = "\(model[row])"
        }
        else if pickerView == pvBoatCountry {
            txtBoatCountry.text = "\(country[row])"
        }
    }
}


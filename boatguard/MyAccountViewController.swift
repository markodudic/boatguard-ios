//
//  MyAccountViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 5/20/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate {
    
    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var txtPassConfirm: UITextField!
    @IBOutlet var txtObuid: UITextField!

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
        txtObuid.text = states.customer["serial_number"].asString!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width:100, height:1000)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    //Events
    @IBAction func btnCancel_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)

    }
    
    @IBAction func btnOk_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
        states.customer["boat_name"] = "test"
        Comm.HTTPPostJSON(settings.customerSetUri, jsonObj: states.customer.toString(pretty: false))

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
    
}


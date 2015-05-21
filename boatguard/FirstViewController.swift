//
//  FirstViewController.swift
//  boatguard
//
//  Created by bl4z on 10/09/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate {

    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var txtObuid: UITextField!
    @IBOutlet var swRemember: UISwitch!
    
    @IBOutlet var viewLoginTitle: UIView!
    @IBOutlet var viewDashboardTitle: UIView!
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var viewDashboard: UIView!
    
    @IBOutlet var tblObusettings: UITableView!
    @IBOutlet var imgLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add gradients
        let gl_login = CAGradientLayer()
        gl_login.colors = [settings.gradientTop, settings.gradientBottom]
        gl_login.locations = [0.0, 1.0]
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl_login.frame = CGRectMake(0,0,viewLogin.layer.frame.width,10)
        }
        else {
            gl_login.frame = CGRectMake(0,0,viewLogin.layer.frame.width,30)
        
        }
        viewLogin.layer.insertSublayer(gl_login, atIndex: 0)
        
        self.txtUser.delegate = self;
        self.txtPass.delegate = self;
        self.txtObuid.delegate = self;
        
        //test login
        #if DEBUG
            txtUser.text = "01104"
            txtPass.text = "01104"
            //txtObuid.text = "12345"
        #endif
        if (states.getRemember()) {
            txtUser.text = states.getUser()
            txtPass.text = states.getPass()
            swRemember.on = states.getRemember()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }

    //Events
    @IBAction func btnRegister_click(sender: UIButton) {
        var urlPath: String = settings.registerUri+"&username="+txtUser.text+"&password="+txtPass.text+"&obu_sn="+txtObuid.text
        checkLoginRegister(urlPath)
    }

    @IBAction func btnLogin_click(sender: UIButton) {
        var urlPath: String = settings.loginUri+"&username="+txtUser.text+"&password="+txtPass.text+"&obu_sn="+txtObuid.text
        checkLoginRegister(urlPath)
    }
        
    func checkLoginRegister(urlPath : String) {
        
        let json = Comm.JSONfromURL(urlPath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        if (json["error"].isDictionary) {
            var alert = UIAlertController(title: json["error"]["name"].asString, message: json["error"]["msg"].asString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            states.setLogin(json)
            states.setObuid(json["obu"]["uid"].asInt!)
            states.setUser(txtUser.text)
            states.setPass(txtPass.text)
            states.setRemember(swRemember.on)
            states.setSessionId(json["sessionId"].asString!)
            getobusettings(states.getObuid())
            setDevice()
        }
    }

    func setDevice() {
        /*println("**************")
        println(UIDevice.currentDevice().userInterfaceIdiom.rawValue)
        println(UIDevice.currentDevice().description)
        println(UIDevice.currentDevice().identifierForVendor.UUIDString)
        println(UIDevice.currentDevice().localizedModel)
        println(UIDevice.currentDevice().model)
        println(UIDevice.currentDevice().name)
        println(UIDevice.currentDevice().systemName)
        println(UIDevice.currentDevice().systemVersion)
        println(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as String)
    */
        let customer = states.getCustomer()["uid"]
        let appVersion = (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as String)
        let device = UIDevice.currentDevice()
        
        var deviceJson = "{\"id_obu\":\""+String(states.obuid)
        deviceJson += "\", \"id_customer\":\""+customer.description
        deviceJson += "\", \"phone_model\":\""+device.localizedModel
        deviceJson += "\", \"phone_platform\":\""+device.systemName
        deviceJson += "\", \"phone_platform_version\":\""+device.systemVersion
        deviceJson += "\", \"phone_uuid\":\""+device.identifierForVendor.UUIDString
        deviceJson += "\", \"app_version\":\""+appVersion+"\"}"
        
        Comm.HTTPPostJSON(settings.deviceUri, jsonObj: deviceJson)
    }

    func getobusettings(obuid: Int) {
        self.tabBarController?.tabBar.hidden = false
        
        //appsettings
        let appsettingsJSON  = Comm.JSONfromURL(settings.settingsUri)
        states.setAppsettings(appsettingsJSON)
        
        //obusettings
        let obusettingsURL   = settings.obusettingsUri+"?format=json&obuid="+String(obuid)
        let obusettingsJSON  = Comm.JSONfromURL(obusettingsURL)
        states.setObusettings(obusettingsJSON)
        
        //obucomponents
        let obucomponentsURL  = settings.obucomponentsUri+"?obuid="+String(obuid)
        let obucomponentsJSON = Comm.JSONfromURL(obucomponentsURL)
        states.setObucomponents(obucomponentsJSON)
        
        //customer
        let customerURL  = settings.customerUri+"?obuid="+String(obuid)
        let customerJSON  = Comm.JSONfromURL(customerURL)
        states.setCustomer(customerJSON)

        //obudata
        let obudataURL        = settings.obudataUri+"?obuid="+String(obuid)
        let obudataJSON       = Comm.JSONfromURL(obudataURL)
        states.setObudata(obudataJSON)
        
        //history
        let historyURL  = settings.historyUri+"?obuid="+String(obuid)
        let historyJSON  = Comm.JSONfromURL(historyURL)
        states.setHistory(historyJSON)
        //println(historyJSON)

        var storyboard = UIStoryboard(name: "Main_ipad", bundle: nil)
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
        let tabController = storyboard.instantiateViewControllerWithIdentifier("TabController") as? UIViewController
        presentViewController(tabController!, animated:false, completion:nil)
        
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

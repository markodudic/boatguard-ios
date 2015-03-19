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
            gl_login.frame = CGRectMake(0,40,viewLogin.layer.frame.width,30)
        
        }
        viewLogin.layer.insertSublayer(gl_login, atIndex: 0)
        
        //test login
        txtUser.text = "marko"
        txtPass.text = "dudic"
        //txtObuid.text = "12345"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }

    //Events
    @IBAction func btnRegister_click(sender: UIButton) {
        var urlPath: String = settings.registerUri+"&username="+txtUser.text+"&password="+txtPass.text+"&obu_sn="+txtObuid.text+"&app_version=1"
        let json = JSON.fromURL(urlPath)

        if (json["error"].isDictionary){
            var alert = UIAlertController(title: json["error"]["name"].asString, message: json["error"]["msg"].asString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            states.setLogin(json)
            getobusettings(json["obu"]["uid"].asInt!)
        }
    }

    @IBAction func btnLogin_click(sender: UIButton) {
        var urlPath: String = settings.loginUri+"&username="+txtUser.text+"&password="+txtPass.text+"&obu_sn="+txtObuid.text+"&app_version=1"
        
        let json = JSON.fromURL(urlPath)
       
        if (json["error"].isDictionary) {
            var alert = UIAlertController(title: json["error"]["name"].asString, message: json["error"]["msg"].asString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            states.setLogin(json)
            states.setObuid(json["obu"]["uid"].asInt!)
            getobusettings(states.getObuid())
        }
    }
    
    func getobusettings(obuid: Int) {
        self.tabBarController?.tabBar.hidden = false
        
        //appsettings
        let appsettingsJSON  = JSON.fromURL(settings.settingsUri)
        states.setAppsettings(appsettingsJSON)
        
        //obusettings
        let obusettingsURL   = settings.obusettingsUri+"?format=json&obuid="+String(obuid)
        let obusettingsJSON  = JSON.fromURL(obusettingsURL)
        states.setObusettings(obusettingsJSON)
        
        //obucomponents
        let obucomponentsURL  = settings.obucomponentsUri+"?obuid="+String(obuid)
        let obucomponentsJSON = JSON.fromURL(obucomponentsURL)
        states.setObucomponents(obucomponentsJSON)
        
        //obudata
        let obudataURL        = settings.obudataUri+"?obuid="+String(obuid)
        let obudataJSON       = JSON.fromURL(obudataURL)
        states.setObudata(obudataJSON)
        println(obudataJSON)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabController = storyboard.instantiateViewControllerWithIdentifier("TabController") as? UIViewController
        presentViewController(tabController!, animated:false, completion:nil)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

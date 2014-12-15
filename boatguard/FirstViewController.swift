//
//  FirstViewController.swift
//  boatguard
//
//  Created by bl4z on 10/09/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var txtObuid: UITextField!
    
    @IBOutlet var viewLoginTitle: UIView!
    @IBOutlet var viewDashboardTitle: UIView!
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var viewDashboard: UIView!
    
    @IBOutlet var tblObusettings: UITableView!
    @IBOutlet var imgLogo: UIImageView!
    
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //add gradients
        let gl_login = CAGradientLayer()
        gl_login.colors = [settings.gradientTop, settings.gradientBottom]
        gl_login.locations = [0.0, 1.0]
        gl_login.frame = CGRectMake(0,0,320,10)
        viewLogin.layer.insertSublayer(gl_login, atIndex: 0)
        
        let gl_dash = CAGradientLayer()
        gl_dash.colors = [settings.gradientTop, settings.gradientBottom]
        gl_dash.locations = [0.0, 1.0]
        gl_dash.frame = CGRectMake(0,0,320,10)
        viewDashboard.layer.insertSublayer(gl_dash, atIndex: 0)
        
        //set toolbar highlighting color
        self.tabBarController?.tabBar.tintColor = UIColor(red: CGFloat(0.607843), green: CGFloat(0.607843), blue: CGFloat(0.607843), alpha: CGFloat(1))
        
        //test login
        txtUser.text = "marko"
        txtPass.text = "dudic"
        txtObuid.text = "12345"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        
        /*if (states.isAlarm) {
            imgLogo.image = UIImage(named: "logo_alarm")
        } else {
            imgLogo.image = UIImage(named: "logo")
        }*/
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
        viewDashboardTitle.hidden = false
        viewDashboard.hidden = false

        viewLoginTitle.hidden = true
        viewLogin.hidden = true
        
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
        
        refresh.setView(self) //send view to refresh
        refresh.addComponents() //add components to view
        refresh.process()
        self.tabBarController?.selectedIndex = 1
        
        //refresh thread
        Async.background {
            while(true) {
                sleep(300)
                states.setObudata(JSON.fromURL(settings.obudataUri+"?obuid="+String(obuid)))
                refresh.process()
            }
        }
    }
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var json = states.getObusettings()
        return json.length
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        
        var json = states.getObusettings()
        cell.textLabel.text = states.dblSpace(json[indexPath.row]["code"].asString!)
        cell.detailTextLabel?.text = states.dblSpace(json[indexPath.row]["value"].asString!)
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        
        return cell
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

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
    
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var viewDashboard: UIView!
    
    @IBOutlet var tblObusettings: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.hidden = true
        viewDashboard.hidden = true
        
        //dedolt login
        txtUser.text = "marko"
        txtPass.text = "dudic"
        txtObuid.text = "123456"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    //Events
    @IBAction func btnRegister_click(sender: UIButton) {
        var urlPath: String = "http://93.103.12.155:8080/boatguard/login?type=register&username="+txtUser.text+"&password="+txtPass.text+"&obu_sn="+txtObuid.text+"&app_version=1"
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
        var urlPath: String = "http://93.103.12.155:8080/boatguard/login?type=login&username="+txtUser.text+"&password="+txtPass.text+"&obu_sn="+txtObuid.text+"&app_version=1"
        
        let json = JSON.fromURL(urlPath)
       
        if (json["error"].isDictionary) {
            var alert = UIAlertController(title: json["error"]["name"].asString, message: json["error"]["msg"].asString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            states.setLogin(json)
            getobusettings(json["obu"]["uid"].asInt!)
        }
    }
    
    func getobusettings(obuid: Int) {
        self.tabBarController?.tabBar.hidden = false
        viewDashboard.hidden = false
        viewLogin.hidden = true
        
        //appsettings
        let appsettingsURL   = "http://93.103.12.155:8080/boatguard/getsettings"
        let appsettingsJSON  = JSON.fromURL(appsettingsURL)
        states.setAppsettings(appsettingsJSON)
        
        //obusettings
        let obusettingsURL   = "http://93.103.12.155:8080/boatguard/getobusettings?format=json&obuid="+String(obuid)
        let obusettingsJSON  = JSON.fromURL(obusettingsURL)
        states.setObusettings(obusettingsJSON)
        
        //obudata
        let obudataURL        = "http://93.103.12.155:8080/boatguard/getdata?obuid="+String(obuid)
        let obudataJSON       = JSON.fromURL(obudataURL)
        states.setObudata(obudataJSON)
        
        //obucomponents
        let obucomponentsURL  = "http://93.103.12.155:8080/boatguard/getobucomponents?obuid="+String(obuid)
        let obucomponentsJSON = JSON.fromURL(obucomponentsURL)
        states.setObucomponents(obucomponentsJSON)
        
        self.handleComponents()
        self.tabBarController?.selectedIndex = 1
        self.handleAlarms()

        //refresh thread
        Async.background {
            while(true) {
                sleep(60)
                states.setObudata(JSON.fromURL(obudataURL))
                self.handleAlarms()
            }
        }
    }

    func handleComponents() {
        var idx = 0
        for (i, v) in states.getObucomponents() {
            if (v["show"].asInt == 1) {
                self.handelComponent(idx)
            }
            idx++
        }
    }
    
    func handelComponent(idx: Int) {
        var json = states.getObucomponent(idx)
        
        var cell: UITableViewCell!
        
        if (json["type"].asString == "PUMP") {
            cell = components.renderCellPump(json)
        } else if (json["type"].asString == "ANCHOR") {
            cell = components.renderCellAnchor(json)
        } else if (json["type"].asString == "GEO") {
            cell = components.renderCellGeo(json)
        } else if (json["type"].asString == "ACCU") {
            cell = components.renderCellAccu(json)
        } else {
            cell = components.renderCellUnknown(json)
        }
        components.addComponent(json["id_component"].asInt!, alarm: false, cell: cell)
    }
    
    //ALARMS
    func handleAlarms() {
        var json = states.getObudata()
        for (i, v) in json["alarms"] {
            components.setAlarm(v["id_alarm"].asInt!)
            self.displayAlarm(v["title"].asString!, message: v["message"].asString!)
        }
    }
    
    func displayAlarm(title: String, message: String) {
        if (states.getIsBackground()) {
            let notification: UILocalNotification = UILocalNotification()
            notification.timeZone = NSTimeZone.defaultTimeZone()
            
            let dateTime = NSDate()
            notification.fireDate    = dateTime
            notification.alertBody   = title
            notification.alertAction = message
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            });
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var json = states.getObusettings()
        return json.length
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        
        var json = states.getObusettings()
        cell.textLabel?.text = json[indexPath.row]["code"].asString
        cell.detailTextLabel?.text = json[indexPath.row]["value"].asString
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        
        return cell
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
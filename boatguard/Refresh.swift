//
//  Refresh.swift
//  boatguard
//
//  Created by bl4z on 01/11/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import Foundation
import UIKit

var refresh: Refresh = Refresh()

class Refresh: NSObject {
    
    var view: UIViewController!
    
    func setView(v: UIViewController) -> Void {
        view = v
    }
    
    func process() -> Void {
        self.handleAlarms()
        self.handleComponents()
    }

    //ALARMS
    func handleAlarms() {
        states.setIsAlarm(false)
        var json = states.getObudata()
        for (i, v) in json["alarms"] {
            states.setIsAlarm(true)
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
                self.view.presentViewController(alert, animated: true, completion: nil)
            });
        }
    }
    
    //COMPONENTS
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
}

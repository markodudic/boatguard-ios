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
    var refreshSemaphoreGo: Bool = true
    
    func setView(v: UIViewController) -> Void {
        view = v
    }

    //COMPONENTS for display
    func addComponents() {
        var idx = 0
        components.removeAllComponents()
        for (i, v) in states.getObucomponents() {
            if (v["show"].asInt == 1) {
                handelComponent(idx)
            }
            idx++
        }
    }
    
    func handelComponent(idx: Int) {
        var json = states.getObucomponent(idx)
        var type = "unknown"

        if (json["type"].asString == "PUMP") {
            type = "PUMP"
        } else if (json["type"].asString == "ANCHOR") {
            type = "ANCHOR"
        } else if (json["type"].asString == "GEO") {
            type = "GEO"
        } else if (json["type"].asString == "ACCU") {
            type = "ACCU"
        }
        components.addComponent(json["id_component"].asInt!, json: json, alarm: false, type: type)
    }
    
    //proces recived JSON
    func process() -> Void {
        if (refreshSemaphoreGo) {
            refreshSemaphoreGo = false
            handleAlarms()
            handleComponents()
            refreshSemaphoreGo = true
        }
    }

    //ALARMS for notification
    func handleAlarms() {
        var json = states.getObudata()
        for (i, v) in json["alarms"] {
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
    
    //COMPONENTS for alarms
    func handleComponents() {
        var idx = 0
        for (i, v) in states.getObucomponents() {
            if (v["show"].asInt == 1) {
                handleComponentAlarms(idx)
            }
            idx++
        }
    }
    
    func handleComponentAlarms(idx: Int) {
        var json = states.getObucomponent(idx)
        
        if (json["type"].asString == "PUMP") {
            components.alarmCellPump(json)
        } else if (json["type"].asString == "ANCHOR") {
            components.alarmCellAnchor(json)
        } else if (json["type"].asString == "GEO") {
            components.alarmCellGeo(json)
        } else if (json["type"].asString == "ACCU") {
            components.alarmCellAccu(json)
        } else {
            components.alarmCellUnknown(json)
        }
    }
}

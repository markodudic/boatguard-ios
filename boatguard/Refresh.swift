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
    
    func process() -> Void {
        if (refreshSemaphoreGo) {
            refreshSemaphoreGo = false
            self.handleAlarms()
            self.handleComponents()
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
    
    //COMPONENTS for display
    func addComponents() {
        var idx = 0
        components.removeAllComponents()
        for (i, v) in states.getObucomponents() {
            if (v["show"].asInt == 1) {
                self.handelComponent(idx)
                self.handleComponentAlarms(idx)
            }
            idx++
        }
    }
    
    func handleComponents() {
        var idx = 0
        for (i, v) in states.getObucomponents() {
            if (v["show"].asInt == 1) {
                self.handleComponentAlarms(idx)
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

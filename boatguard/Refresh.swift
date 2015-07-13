//
//  Refresh.swift
//  boatguard
//
//  Created by bl4z on 01/11/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import AVFoundation

var refresh: Refresh = Refresh()

class Refresh: NSObject {
    
    var view: UIViewController!
    var refreshSemaphoreGo: Bool = true
    
    func setView1(v: UIViewController) -> Void {
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
        } else if (json["type"].asString == "LIGHT") {
            type = "LIGHT"
        } else if (json["type"].asString == "FAN") {
            type = "FAN"
        } else if (json["type"].asString == "DOOR") {
            type = "DOOR"
        }
        components.addComponent(json["id_component"].asInt!, json: json, alarm: false, type: type)
    }
    
    //proces recived JSON
    func process() -> Void {
        if (refreshSemaphoreGo) {
            println("refresh start")
            println(NSDate())
            refreshSemaphoreGo = false
            handleAlarms()
            handleComponents()
            refreshSemaphoreGo = true
            println("refresh end")
        }
    }

    //notification alarms
    func handleAlarms() {
        if NSUserDefaults.standardUserDefaults().boolForKey("SETTING_POP_UP") {
        
            var json = states.getObudata()
            for (i, v) in json["alarms"] {
                self.displayAlarm(v["title"].asString!, message: v["message"].asString!, id_alarm: v["id_alarm"].asInt!, vibrate: v["vibrate"].asInt!, sound: v["sound"].asInt!)
            }
        }
    }
    
    func displayAlarm(title: String, message: String, id_alarm: Int, vibrate: Int, sound: Int) {

        //handle single alarm just once
        if (states.getIdAlarm() != id_alarm) {
            //push notification
            if (states.getIsBackground()) {
                let notification: UILocalNotification = UILocalNotification()
                notification.timeZone = NSTimeZone.defaultTimeZone()
                
                let dateTime = NSDate()
                notification.fireDate    = dateTime
                notification.alertBody   = title
                notification.alertAction = message
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            } else {
                if (vibrate == 1 && NSUserDefaults.standardUserDefaults().boolForKey("SETTING_VIBRATE")) {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            
                if (sound == 1 && NSUserDefaults.standardUserDefaults().boolForKey("SETTING_PLAY_SOUND")) {
                    var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("horn", ofType: "wav")!)
                    var audioPlayer = AVAudioPlayer()
                    audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: nil)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                }
            
                dispatch_async(dispatch_get_main_queue(), {
                    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.confirmAlarm(id_alarm)}))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in self.confirmAlarm(id_alarm)}))
                    self.view.presentViewController(alert, animated: true, completion: nil)
               });
            }
            states.setIdAlarm1(id_alarm)
            
        }
    }
    
    func confirmAlarm(id_alarm: Int) {
        //confirm
        let obualarmJSON = JSON.fromURL(settings.obualarmUri+"?obuid="+String(states.obuid)+"&alarmid="+String(id_alarm))

        states.setIdAlarm1(0)
        
        //refresh
        states.setObudata(JSON.fromURL(settings.obudataUri+"?obuid="+String(states.getObuid())))
        process()
    }

        
    //component states
    func handleComponents() {
        
        //unset b4 process
        components.unsetAlarms()
        
        //iterate components
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
        } else if (json["type"].asString == "LIGHT") {
            components.alarmCellLight(json)
        } else if (json["type"].asString == "FAN") {
            components.alarmCellFan(json)
        } else if (json["type"].asString == "DOOR") {
            components.alarmCellDoor(json)
        }
    }
}

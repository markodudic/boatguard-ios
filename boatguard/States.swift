//
//  States.swift
//  boatguard
//
//  Created by bl4z on 22/09/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import Foundation

var states: States = States()

class States: NSObject {
  
    var isBackground = false
    var isAlarm      = false
    var obuid        = 0
    
    var login:JSON!
    var appsettings:JSON!
    
    var obusettings:JSON!
    var obucomponents:JSON!
    var obudata:JSON!
    var obudatadateTime = NSDate()

    func setIsBackground(data: Bool) {
        isBackground = data
    }
    func getIsBackground() -> Bool {
        return isBackground
    }

    func setIsAlarmOn() {
        isAlarm = true
    }

    func setIsAlarmOff() {
        isAlarm = false
    }
    
    func getIsAlarm() -> Bool {
        return isAlarm
    }
    
    func setObuid(data: Int) {
        obuid = data
    }
    func getObuid() -> Int {
        return obuid
    }
    
    func setLogin(data: JSON) {
        login = data
    }
    func getLogin() -> JSON {
        return login
    }
    
    func setAppsettings(data: JSON) {
        appsettings = data
    }
    func getAppsettings() -> JSON {
        return appsettings
    }
    
    func setObusettings(data: JSON) {
        obusettings = data
    }
    func getObusettings() -> JSON {
        if (obusettings == nil) {
            return JSON([])
        } else {
            return obusettings
        }
    }
    
    func setObucomponents(data: JSON) {
        obucomponents = data
    }
    func getObucomponents() -> JSON {
        return obucomponents
    }
    func getObucomponent(i: Int) -> JSON {
        return obucomponents[i]
    }

    func setObudata(data: JSON) {
        //update refresh time
        obudatadateTime = NSDate()
        obudata = data
    }
    
    func getObudata() -> JSON {
        return obudata
    }
    
    func getObudataBystate(id_state: Int) -> JSON {
        for (i, v) in obudata["states"] {
            if (v["id_state"].asInt == id_state) {
                return v
            }
        }
        return JSON([])
    }

    func getAlarmSettingsById(id: Int) -> JSON {
        for (i, v) in appsettings["alarms"] {
            if (v["active"].asInt == 1 && v["id"].asInt == id) {
                return v
            }
        }
        return JSON([])
    }
    
    func getComponentStates(id_component: Int) -> [JSON] {
        var comp = [JSON]()
        for (i, v) in appsettings["states"] {
            if (v["id_component"].asInt == id_component) {
                comp.append(v)
            }
        }
        return comp
    }
    
    func getObudatadateTime() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        return dateFormatter.stringFromDate(obudatadateTime)
    }
}

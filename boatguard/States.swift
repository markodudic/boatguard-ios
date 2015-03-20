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
    var idAlarm      = 0
    var obuid        = 0
    
    var login:JSON!
    var user = ""
    var pass = ""
    var remember = false
    var appsettings:JSON!
    
    var obusettings:JSON!
    var obucomponents:JSON!
    var obudata:JSON!
    var obudatadateTime = NSDate()

    func setUser(data: String) {
        user = data
    }
    
    func getUser() -> String {
        return user
    }

    func setPass(data: String) {
        pass = data
    }
    
    func getPass() -> String {
        return pass
    }

    func setRemember(data: Bool) {
        remember = data
    }
    
    func getRemember() -> Bool {
        return remember
    }

    func setIsBackground(data: Bool) {
        isBackground = data
    }
    func getIsBackground() -> Bool {
        return isBackground
    }

    func setIsAlarm(data: Bool) {
        isAlarm = data
    }
    
    func getIsAlarm() -> Bool {
        return isAlarm
    }

    func setIdAlarm(data: Int) {
        idAlarm = data
    }
    
    func getIdAlarm() -> Int {
        return idAlarm
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
        obudata = data
        obudatadateTime = NSDate()
    }
    
    func getObudata() -> JSON {
        return obudata
    }
    
    func getObudataByIdState(id_state: Int) -> JSON {
        for (i, v) in obudata["states"] {
            if (v["id_state"].asInt == id_state) {
                return v
            }
        }
        return JSON([])
    }

    func getAlarmSettingsByIdState(id_state: Int) -> [JSON] {
        var a = [JSON]()
        for (i, v) in appsettings["alarms"] {
            if (v["active"].asInt == 1 && v["id_state"].asInt == id_state) {
                a.append(v)
            }
        }
        return a
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

    func dblSpace(s: String) -> String {
        let characters = Array(s)
        var dbl:String = ""
        for c in characters {
            dbl += [c] + " "
        }
        return dbl
    }
    
    /*
    * states timestamp
    */
    func getObudatadateTime() -> String {

        var d:String!
        var v = obudata["states"]
        for (i, v) in obudata["states"] {
            if (v["id_state"].asInt == 1) {
                d = v["dateString"].asString!
            }
        }
        return d
    }
    
    /*
    * convert numbers
    */
    func toDecimal(s: String, decimals: Int)-> String {
        let numberFormatter = NSNumberFormatter()
        let number = numberFormatter.numberFromString(s)
        
        //TODO nil?
        //wox in simulator not on device
        let numberFloatValue = number?.floatValue
        
        if (numberFloatValue != nil) {
            return dblSpace(String(format: "%."+String(decimals)+"f", numberFloatValue!))
        } else {
            return dblSpace(s)
        }
    }
}
//
//  States.swift
//  boatguard
//
//  Created by bl4z on 22/09/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit

var states: States = States()

class States: NSObject {
  
    var isBackground = false
    
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
    
    func setObudata(data: JSON) {
        //update refresh time
        obudatadateTime = NSDate()
        obudata = data
    }
    func getObudata() -> JSON {
        return obudata
    }
    
    func getObudatadateTime() -> String {
        return obudatadateTime.description
    }
}

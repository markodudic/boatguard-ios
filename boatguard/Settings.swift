//
//  Settings.swift
//  boatguard
//
//  Created by bl4z on 01/11/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import Foundation
import UIKit

var settings: Settings = Settings()

class Settings: NSObject {
    internal let flurryKey          = "83VV9ZX37HNWD2KSYYQJ"
    
    internal let registerUri        = "http://93.103.12.155:8080/boatguard/login?type=register"
    internal let loginUri           = "http://93.103.12.155:8080/boatguard/login?type=login"
    internal let settingsUri        = "http://93.103.12.155:8080/boatguard/getsettings"
    internal let obusettingsUri     = "http://93.103.12.155:8080/boatguard/getobusettings"
    internal let obusettingsSetUri  = "http://93.103.12.155:8080/boatguard/setobusettings"
    internal let obucomponentsUri   = "http://93.103.12.155:8080/boatguard/getobucomponents"
    internal let obudataUri         = "http://93.103.12.155:8080/boatguard/getdata"
    internal let obualarmUri        = "http://93.103.12.155:8080/boatguard/confirmalarm"
    
    internal var refreshTime:UInt32      = 300
    
    internal let gradientTop      = UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 0.4).CGColor
    internal let gradientBottom   = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 0).CGColor

    internal let gradientTop_a    = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6).CGColor
    internal let gradientBottom_a = UIColor(red: 212.0/255.0, green: 69.0/255.0, blue: 29.0/255.0, alpha: 0).CGColor

    internal let cellNormal       = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 0.6)
    internal let cellAlarm        = UIColor(red: 193.0/255.0, green: 68.0/255.0, blue: 30.0/255.0, alpha: 0.6)
    
    internal let lblGreen         = UIColor(red: 57.0/255.0, green: 169.0/255.0, blue: 53.0/255.0, alpha: 1)
    internal let lblRed           = UIColor(red: 212.0/255.0, green: 69.0/255.0, blue: 29.0/255.0, alpha: 1)

    internal let refresh           = UIColor(red: 109.0/255.0, green: 116.0/255.0, blue: 124.0/255.0, alpha: 1)
    
    internal let settingsTableData = ["GEOFENCE","BILGE PUMP","ANCHOR DRIFTING","BATTERY","ALARM CONTACTS","ALARM SETTINGS","MY ACCOUNT","HISTORY","APP SETTINGS","LOG OUT"]
}

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
    internal let registerUri      = "http://93.103.12.155:8080/boatguard/login?type=register"
    internal let loginUri         = "http://93.103.12.155:8080/boatguard/login?type=login"
    internal let settingsUri      = "http://93.103.12.155:8080/boatguard/getsettings"
    internal let obusettingsUri   = "http://93.103.12.155:8080/boatguard/getobusettings"
    internal let obucomponentsUri = "http://93.103.12.155:8080/boatguard/getobucomponents"
    internal let obudataUri       = "http://93.103.12.155:8080/boatguard/getdata"
    internal let obualarmUri      = "http://93.103.12.155:8080/boatguard/confirmalarm"
    
    internal let gradientTop    = UIColor(red: 172.0/255.0, green: 173.0/255.0, blue: 174.0/255.0, alpha: 0.9).CGColor
    internal let gradientBottom = UIColor(red: 213.0/255.0, green: 214.0/255.0, blue: 215.0/255.0, alpha: 0.1).CGColor
    
    internal let cellNormal     = UIColor(red: 226.0/255.0, green: 225.0/255.0, blue: 226.0/255.0, alpha: 1)
    internal let cellAlarm      = UIColor(red: 213.0/255.0, green: 14.0/255.0, blue: 15.0/255.0, alpha: 0.5)
}

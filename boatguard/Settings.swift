//
//  Settings.swift
//  boatguard
//
//  Created by bl4z on 01/11/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit

var settings: Settings = Settings()

class Settings: NSObject {
    internal let registerUri       = "http://93.103.12.155:8080/boatguard/login?type=register"
    internal let loginUri          = "http://93.103.12.155:8080/boatguard/login?type=login"
    internal let settingsUri       = "http://93.103.12.155:8080/boatguard/getsettings"
    internal let obusettingsUri    = "http://93.103.12.155:8080/boatguard/getobusettings"
    internal let obucomponentsUri  = "http://93.103.12.155:8080/boatguard/getobucomponents"
    internal let obudataUri        = "http://93.103.12.155:8080/boatguard/getdata"
}

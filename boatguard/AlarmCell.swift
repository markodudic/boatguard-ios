//
//  AlarmCell.swift
//  boatguard
//
//  Created by Marko Dudic on 6/4/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

extension Bool {
    func toInt() -> Int? {
        if self {
            return 1
        }
        else {
            return 0
        }
    }
}

class AlarmCell: UITableViewCell {
    
    @IBOutlet weak var lblAlarmName: UILabel!
    @IBOutlet weak var swAlarmOn: UISwitch!
    @IBOutlet weak var swSendEmail: UISwitch!
    @IBOutlet weak var swAlarmFriends: UISwitch!
    
    var alarmId: Int = 0
    
    func swChanged(id: Int) {
        alarmId = id
        
        swAlarmOn.addTarget(self, action: Selector("swOnChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        swSendEmail.addTarget(self, action: Selector("swOnChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        swAlarmFriends.addTarget(self, action: Selector("swOnChanged:"), forControlEvents: UIControlEvents.ValueChanged)
     }
    
    @IBAction func swOnChanged(sender: UISwitch) {
        states.setAlarm(alarmId, active: swAlarmOn.on.toInt()!, send_email: swSendEmail.on.toInt()!, send_friends: swAlarmFriends.on.toInt()!)
        Comm.HTTPPostJSON(settings.obuAlarmsSetUri, jsonObj: states.alarms.toString(pretty: false))
    }


}
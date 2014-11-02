//
//  Components.swift
//  boatguard
//
//  Created by bl4z on 04/10/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit

var components: Components = Components()

class comp {
    var id    = 0
    var alarm = false
    var cell: UITableViewCell!
}

class Components: NSObject {
    
    var comps = [comp]()
    
    func addComponent(id: Int, alarm: Bool, cell: UITableViewCell) {
        var c = comp()
        c.id    = id
        c.alarm = alarm
        c.cell  = cell
        comps.append(c);
    }
    
    func removeAllComponents() -> Void {
        comps = []
    }
    
    func getComponents() -> [comp] {
        return comps
    }
    
    func getComponent(idx: Int) -> comp {
        return comps[idx]
    }
    
    func getComponentsCount() -> Int {
        return comps.count
    }
    
    func setAlarm(id: Int) {
        for c in comps {
            if (c.id == id) {
                c.alarm = true
            }
        }
    }
  
    func renderCellUnknown(json: JSON) ->UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "unknown")
        cell.textLabel.text = json["name"].asString
        cell.detailTextLabel?.text = json["value"].asString
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }
    
    func renderCellPump(json: JSON) ->UITableViewCell {
        println("pump")
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        var alarm: Bool = false
        for component_state in component_states {
            let component_data: JSON = states.getObudataBystate(component_state["id"].asInt!)
            let component_alarm: JSON  = states.getAlarmSettingsByState(component_state["id"].asInt!)
            if (calculate_alarm(component_state, data: component_data, alarm: component_alarm)) {
                alarm = true
            }
            if (alarm) {
                break
            }
        }
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "pump")
        cell.textLabel.text = json["name"].asString
        //cell.detailTextLabel?.text =
        cell.imageView.image = UIImage(named: "ic_pump")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }
    
    func renderCellAnchor(json: JSON) ->UITableViewCell {
        println("anchor")
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        var alarm: Bool = false
        for component_state in component_states {
            let component_data: JSON = states.getObudataBystate(component_state["id"].asInt!)
            let component_alarm: JSON  = states.getAlarmSettingsByState(component_state["id"].asInt!)
            if (calculate_alarm(component_state, data: component_data, alarm: component_alarm)) {
                alarm = true
            }
            if (alarm) {
                break
            }
        }
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "anchor")
        cell.textLabel.text = json["name"].asString
        //cell.detailTextLabel?.text =
        cell.imageView.image = UIImage(named: "ic_anchor")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }
    
    func renderCellGeo(json: JSON) ->UITableViewCell {
        println("geo")
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        var alarm: Bool = false
        for component_state in component_states {
            let component_data: JSON = states.getObudataBystate(component_state["id"].asInt!)
            let component_alarm: JSON  = states.getAlarmSettingsByState(component_state["id"].asInt!)
            if (calculate_alarm(component_state, data: component_data, alarm: component_alarm)) {
                alarm = true
            }
            if (alarm) {
                break
            }
        }
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "geo")
        cell.textLabel.text = json["name"].asString
        //cell.detailTextLabel?.text =
        cell.imageView.image = UIImage(named: "ic_geo")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }
    
    func renderCellAccu(json: JSON) ->UITableViewCell {
        println("accu")
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        var alarm: Bool = false
        for component_state in component_states {
            let component_data: JSON = states.getObudataBystate(component_state["id"].asInt!)
            let component_alarm: JSON  = states.getAlarmSettingsByState(component_state["id"].asInt!)
            if (calculate_alarm(component_state, data: component_data, alarm: component_alarm)) {
                alarm = true
            }
            if (alarm) {
                break
            }
        }

        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "accu")
        cell.textLabel.text = json["name"].asString
        //cell.detailTextLabel?.text =
        cell.imageView.image = UIImage(named: "ic_accu")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }
    
    func calculate_alarm(jcomp: JSON, data jdata: JSON, alarm jalarm:JSON) ->Bool {
        println("---")
        println(jcomp)
        println(jdata)
        println(jalarm)
        
        return true
    }
}
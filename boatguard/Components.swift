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
    var type  = "unknown"
    var json:JSON!
}

class Components: NSObject {
    
    var comps = [comp]()
    
    func addComponent(id: Int, json: JSON, alarm: Bool, type: String) {
        var c = comp()
        c.id    = id
        c.json  = json
        c.alarm = alarm
        c.type  = type
        comps.append(c);
    }
    
    func removeAllComponents() -> Void {
        states.setIsAlarm(false)
        comps = []
    }
    
    func getComponents() -> [comp] {
        return comps
    }
    
    func getComponent(idx: Int, tableView: UITableView) -> UITableViewCell {
        var c = comps[idx]
        
        if (c.type == "PUMP") {
            return renderCellPump(idx, tableView: tableView)
        } else if (c.type == "ANCHOR") {
            return renderCellAnchor(idx, tableView: tableView)
        } else if (c.type == "GEO") {
            return renderCellGeo(idx, tableView: tableView)
        } else if (c.type == "ACCU") {
            return renderCellAccu(idx, tableView: tableView)
        }
        return renderCellUnknown(idx, tableView: tableView)
    }
    
    func getComponentsCount() -> Int {
        return comps.count
    }
    
    func setAlarm(id: Int) {
        println("#########################################################alarm for component:")
        println(id)
        states.setIsAlarm(true)
        for c in comps {
            if (c.id == id) {
                c.alarm = true
            }
        }
    }
  
    func renderCellUnknown(idx: Int, tableView: UITableView) ->UITableViewCell {
        var c = comps[idx]
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as ComponentCell
        cell.lbl.text = "-"
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func alarmCellUnknown(json: JSON) ->Bool {
        return false
    }
    
    func renderCellPump(idx: Int, tableView: UITableView) ->UITableViewCell {
        var c = comps[idx]
        var json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as ComponentCell
        cell.lbl.text = json["name"].asString
        cell.img.image = UIImage(named: "ic_pump")
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func alarmCellPump(json: JSON) ->Bool {
        println("---PUMP id component:")
        println(json["id_component"].asInt)
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(component_state["id"].asInt!)
            let component_alarm: JSON  = states.getAlarmSettingsByIdState(component_state["id"].asInt!)
            if (calculate_alarm(component_state, data: component_data, alarm: component_alarm) == true) {
                setAlarm(json["id_component"].asInt!)
                return true
            }
        }
        return false
    }
    
    func renderCellAnchor(idx: Int, tableView: UITableView) ->UITableViewCell {
        var c = comps[idx]
        var json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as ComponentCell
        cell.lbl.text = json["name"].asString
        cell.img.image = UIImage(named: "ic_anchor")
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func alarmCellAnchor(json: JSON) ->Bool {
        println("---ANCHOR id component:")
        println(json["id_component"].asInt)
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(component_state["id"].asInt!)
            let component_alarm: JSON  = states.getAlarmSettingsByIdState(component_state["id"].asInt!)
            if (calculate_alarm(component_state, data: component_data, alarm: component_alarm) == true) {
                setAlarm(json["id_component"].asInt!)
                return true
            }
        }
        return false
    }
    
    func renderCellGeo(idx: Int, tableView: UITableView) ->UITableViewCell {
        var c = comps[idx]
        var json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as ComponentCell
        cell.lbl.text = json["name"].asString
        cell.img.image = UIImage(named: "ic_geo")
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func alarmCellGeo(json: JSON) ->Bool {
        println("---GEO id component:")
        println(json["id_component"].asInt)
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(component_state["id"].asInt!)
            let component_alarm: JSON  = states.getAlarmSettingsByIdState(component_state["id"].asInt!)
            if (calculate_alarm(component_state, data: component_data, alarm: component_alarm) == true) {
                setAlarm(json["id_component"].asInt!)
                return true
            }
        }
        return false
    }
    
    func renderCellAccu(idx: Int, tableView: UITableView) ->UITableViewCell {
        var c = comps[idx]
        var json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as ComponentCell
        cell.lbl.text = json["name"].asString
        cell.img.image = UIImage(named: "ic_accu")
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func alarmCellAccu(json: JSON) ->Bool {
        println("---ACCU id component:")
        println(json["id_component"].asInt)
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(component_state["id"].asInt!)
            let component_alarm: JSON  = states.getAlarmSettingsByIdState(component_state["id"].asInt!)
            if (calculate_alarm(component_state, data: component_data, alarm: component_alarm) == true) {
                println("+++alarm ACCU")
                setAlarm(json["id_component"].asInt!)
                return true
            }
        }
        return false
    }
    
    func calculate_alarm(jcomp: JSON, data jdata: JSON, alarm jalarm:JSON) ->Bool {
        println("******************************is alarm?")
        println("component settings")
        println(jcomp)
        println("alarm settings")
        println(jalarm)
        println("data")
        println(jdata)
        
        if (jalarm["operand"].asError != nil) {
            println("------------------------------no operand")
            return false
        }
        
        if (jdata["value"].asError != nil) {
            println("------------------------------no value")
            return false
        }
      
        let values:String = jcomp["values"].asString!
        let valuesArr = split(values) {$0 == ","}

        println("==============================test")
        println(jcomp["values"].asString)
        println(jalarm["operand"].asString)
        println(jdata["value"].asString)
        
        for value in valuesArr {
            if (jalarm["operand"].asString == ">") {
                if (jdata["value"].asInt > value.toInt()) {
                    return true
                }
            } else if (jalarm["operand"].asString == "<") {
                if (jdata["value"].asInt < value.toInt()) {
                    return true
                }
            } else {
                if (jdata["value"].asString == value) {
                    return true
                }
            }
        }
        return false
    }
}

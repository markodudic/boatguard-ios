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
        return renderCellUnknown(idx, tableView: tableView, name: c.json["type"].asString!)
    }
    
    func getComponentsCount() -> Int {
        return comps.count
    }
    
    func unsetAlarms() -> Void {
        states.setIsAlarm(false)
        for c in comps {
            c.alarm = false
        }
    }
    
    func setAlarm(id: Int) {
        states.setIsAlarm(true)
        for c in comps {
            if (c.id == id) {
                c.alarm = true
            }
        }
    }
  
    func renderCellUnknown(idx: Int, tableView: UITableView, name: String) ->UITableViewCell {
        var c = comps[idx]
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as ComponentCell
        cell.lbl.text = name
        var compImages: [UIImage] = []
        compImages.append(UIImage(named: "ic_unknown")!)
        cell.imgAnimate(compImages)
        return cell
    }
    
    /*
    * PUMP
    */
    func renderCellPump(idx: Int, tableView: UITableView) ->UITableViewCell {
        var c = comps[idx]
        var json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as ComponentCell
        cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImagePump(idx))
        
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func setImagePump(idx: Int) ->[UIImage] {
        var compImages: [UIImage] = []
        let component_data: JSON = states.getObudataByIdState(20)
        let component_value: String = component_data["value"].asString!

        if (component_value == "0") {
            compImages.append(UIImage(named: "ic_ok")!)
        } else if (component_value == "1") {
            compImages.append(UIImage(named: "ic_pump_1_2")!)
            compImages.append(UIImage(named: "ic_pump_1_3")!)
            compImages.append(UIImage(named: "ic_pump_1_4")!)
            compImages.append(UIImage(named: "ic_pump_1_5")!)
            compImages.append(UIImage(named: "ic_pump_1_6")!)
            compImages.append(UIImage(named: "ic_pump_1_7")!)
            compImages.append(UIImage(named: "ic_pump_1_8")!)
            compImages.append(UIImage(named: "ic_pump_1_9")!)
        } else if (component_value == "2") {
            compImages.append(UIImage(named: "ic_pump_2")!)
        } else if (component_value == "3") {
            compImages.append(UIImage(named: "ic_pump_3")!)
        } else {
            compImages.append(UIImage(named: "ic_ok")!)
        }
        
        println(compImages.count)
        return compImages
    }
    
    func alarmCellPump(json: JSON) ->Bool {
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(20)
            if (component_data["value"].asString?.toInt() != 0) {
                setAlarm(json["id_component"].asInt!)
                return true
            }
        }
        return false
    }
    
    /**
    * ANCHOR
    */
    func renderCellAnchor(idx: Int, tableView: UITableView) ->UITableViewCell {
        var c = comps[idx]
        var json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as ComponentCell
        cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImageAnchor(idx))
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func setImageAnchor(idx: Int) ->[UIImage] {
        var compImages: [UIImage] = []
        let component_data40: JSON = states.getObudataByIdState(40)
        let component_value40: String = component_data40["value"].asString!
        let component_data41: JSON = states.getObudataByIdState(41)
        let component_value41: String = component_data41["value"].asString!
        
        if (component_value40 == "0") {
            compImages.append(UIImage(named: "ic_anchor_grey")!)
        } else if (component_value40 == "1" && component_value41 == "0") {
            compImages.append(UIImage(named: "ic_anchor_green")!)
        } else if (component_value41 == "1") {
            compImages.append(UIImage(named: "ic_anchor_red")!)
        } else {
            compImages.append(UIImage(named: "ic_ok")!)
        }
        return compImages
    }
    
    func alarmCellAnchor(json: JSON) ->Bool {
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(41)
            if (component_data["value"].asString?.toInt() == 1) {
                setAlarm(json["id_component"].asInt!)
                return true
            }
        }
        return false
    }
    
    /**
    * GEO
    */
    func renderCellGeo(idx: Int, tableView: UITableView) ->UITableViewCell {
        var c = comps[idx]
        var json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as ComponentCell
        cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImageGeo(idx))
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func setImageGeo(idx: Int) ->[UIImage] {
        var compImages: [UIImage] = []
        let component_data: JSON = states.getObudataByIdState(10)
        let component_value: String = component_data["value"].asString!
        
        if (component_value == "0") {
            compImages.append(UIImage(named: "ic_geo_grey")!)
        } else if (component_value == "1") {
            compImages.append(UIImage(named: "ic_geo_green")!)
        } else if (component_value == "2") {
            compImages.append(UIImage(named: "ic_geo_red")!)
        } else {
            compImages.append(UIImage(named: "ic_ok")!)
        }
        return compImages
    }
    
    func alarmCellGeo(json: JSON) ->Bool {
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(10)
            if (component_data["value"].asString?.toInt() == 2) {
                setAlarm(json["id_component"].asInt!)
                return true
            }
        }
        return false
    }
    
    /**
    * ACCU
    */
    func renderCellAccu(idx: Int, tableView: UITableView) ->UITableViewCell {
        var c = comps[idx]
        var json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as ComponentCell
        cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImageAccu(idx))
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func setImageAccu(idx: Int) ->[UIImage] {
        var compImages: [UIImage] = []
        let component_data33: JSON = states.getObudataByIdState(33)
        let component_value33: String = component_data33["value"].asString!
        let component_data30: JSON = states.getObudataByIdState(30)
        let component_value30: String = component_data30["value"].asString!
        let component_data31: JSON = states.getObudataByIdState(31)
        let component_value31: String = component_data31["value"].asString!
        let component_data32: JSON = states.getObudataByIdState(32)
        let component_value32: String = component_data32["value"].asString!
        
        if (component_value33 == "0") {
            compImages.append(UIImage(named: "ic_accu_disconnected")!)
        } else if (component_value30 == "1") {
            compImages.append(UIImage(named: "ic_acu_30")!)
        } else if (component_value31 == "1") {
            compImages.append(UIImage(named: "ic_acu_31")!)
        } else if (component_value32 == "1") {
            compImages.append(UIImage(named: "ic_acu_32")!)
        } else {
            compImages.append(UIImage(named: "ic_ok")!)
        }
        return compImages
    }
    
    func alarmCellAccu(json: JSON) ->Bool {
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(33)
            if (component_data["value"].asString?.toInt() == 0) {
                setAlarm(json["id_component"].asInt!)
                return true
            }
        }
        for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(34)
            if (component_data["value"].asString?.toInt() == 1) {
                setAlarm(json["id_component"].asInt!)
                return true
            }
        }
        return false
    }
   
    /**
    * common
    */
    func calculate_state(jcomp: JSON, data jdata: JSON, alarm jalarm:JSON) ->Bool {
        if (jdata["value"].asError != nil) {
            return false
        }
        
        if (jcomp["values"].asError != nil) {
            return false
        }
        
        let values:String = jcomp["values"].asString!
        let valuesArr = split(values) {$0 == ","}

        for value in valuesArr {
            if (jdata["value"].asString?.toInt() == value.toInt()) {
                return true
            }
        }
        return false
    }
}

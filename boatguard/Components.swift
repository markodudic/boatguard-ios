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
        let c = comp()
        c.id    = id
        c.json  = json
        c.alarm = alarm
        c.type  = type
        comps.append(c);
    }
    
    func removeAllComponents() -> Void {
        states.setIsAlarm1(false)
        comps = []
    }
    
    func getComponents() -> [comp] {
        return comps
    }
    
    func getComponent(idx: Int, tableView: UITableView) -> UITableViewCell {
        let c = comps[idx]
        
        if (c.type == "PUMP") {
            return renderCellPump(idx, tableView: tableView)
        } else if (c.type == "ANCHOR") {
            return renderCellAnchor(idx, tableView: tableView)
        } else if (c.type == "GEO") {
            return renderCellGeo(idx, tableView: tableView)
        } else if (c.type == "ACCU") {
            return renderCellAccu(idx, tableView: tableView)
        } else if (c.type == "LIGHT") {
            return renderCellLight(idx, tableView: tableView)
        } else if (c.type == "FAN") {
            return renderCellFan(idx, tableView: tableView)
        } else if (c.type == "DOOR") {
            return renderCellDoor(idx, tableView: tableView)
        }
        return renderCellUnknown(idx, tableView: tableView, name: c.json["type"].asString!)
    }
    
    func getComponentsCount() -> Int {
        return comps.count
    }
    
    func unsetAlarms() -> Void {
        states.setIsAlarm1(false)
        for c in comps {
            c.alarm = false
        }
    }
    
    func setAlarm(id: Int) {
        states.setIsAlarm1(true)
        for c in comps {
            if (c.id == id) {
                c.alarm = true
            }
        }
    }
  
    func renderCellUnknown(idx: Int, tableView: UITableView, name: String) ->UITableViewCell {
        var c = comps[idx]
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as! ComponentCell
        cell.lbl.text = name
        var compImages: [UIImage] = []
        compImages.append(UIImage(named: "ic_unknown")!)
        cell.imgAnimate(compImages)
        cell.offCellAnimation()
        return cell
    }
    
    /*
    * PUMP
    */
    func renderCellPump(idx: Int, tableView: UITableView) ->UITableViewCell {
        let c = comps[idx]
        let json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as! ComponentCell
        cell.setCellName("PUMP")
        cell.lbl.attributedText = NSAttributedString(string: json["name"].asString!, attributes: [NSKernAttributeName:4])
        //cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImagePump(idx))
        cell.imgBanner([])
        
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
        if (component_data.length > 0) {
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
            } else if (component_value > "3") {
                compImages.append(UIImage(named: "ic_pump_4")!)
            }
        }
        
        if (compImages.count == 0) {
            compImages.append(UIImage(named: "ic_pump_grey")!)
        }
        return compImages
    }
    
    func alarmCellPump(json: JSON) ->Bool {
        //let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        //for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(20)
            if (component_data.length > 0) {
                if (Int((component_data["value"].asString)!) != 0) {
                    setAlarm(json["id_component"].asInt!)
                    return true
                }
            }
        //}
        return false
    }
    
    /**
    * ANCHOR
    */
    func renderCellAnchor(idx: Int, tableView: UITableView) ->UITableViewCell {
        let c = comps[idx]
        let json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as! ComponentCell
        cell.setCellName("ANCHOR")
        cell.lbl.attributedText = NSAttributedString(string: json["name"].asString!, attributes: [NSKernAttributeName:4])
        //cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImageAnchor(idx))
        cell.imgBanner([])
        
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
        let component_data41: JSON = states.getObudataByIdState(41)

        if (component_data40.length > 0 && component_data41.length > 0) {
            let component_value40: String = component_data40["value"].asString!
            let component_value41: String = component_data41["value"].asString!
        
            if (component_value40 == "0") {
                compImages.append(UIImage(named: "ic_anchor_grey")!)
            } else if (component_value40 == "1" && component_value41 == "0") {
                compImages.append(UIImage(named: "ic_anchor_green")!)
            } else if (component_value41 == "1") {
                compImages.append(UIImage(named: "ic_anchor_red")!)
            }
        }
        
        if (compImages.count == 0) {
            compImages.append(UIImage(named: "ic_anchor_grey")!)
        }
        return compImages
    }
    
    func alarmCellAnchor(json: JSON) ->Bool {
        //let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        //for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(41)
            if (component_data.length > 0) {
                if (Int((component_data["value"].asString)!)! == 1) {
                    setAlarm(json["id_component"].asInt!)
                    return true
                }
            }
        //}
        return false
    }
    
    /**
    * GEO
    */
    func renderCellGeo(idx: Int, tableView: UITableView) ->UITableViewCell {
        let c = comps[idx]
        let json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as! ComponentCell
        cell.setCellName("GEO")
        cell.lbl.attributedText = NSAttributedString(string: json["name"].asString!, attributes: [NSKernAttributeName:4])
        //cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImageGeo(idx))
        cell.imgBanner([])
        
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
        if (component_data.length > 0) {
            let component_value: String = component_data["value"].asString!
        
            if (component_value == "0") {
                compImages.append(UIImage(named: "ic_geo_grey")!)
            } else if (component_value == "1") {
                compImages.append(UIImage(named: "ic_geo_green")!)
            } else if (component_value == "2") {
                compImages.append(UIImage(named: "ic_geo_red")!)
            }
        }
        
        if (compImages.count == 0) {
            compImages.append(UIImage(named: "ic_geo_grey")!)
        }
        return compImages
    }
    
    func alarmCellGeo(json: JSON) ->Bool {
        //let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        //for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(10)
            if (Int((component_data["value"].asString)!) == 2) {
                setAlarm(json["id_component"].asInt!)
                return true
            }
        //}
        return false
    }
    
    /**
    * ACCU
    */
    func renderCellAccu(idx: Int, tableView: UITableView) ->UITableViewCell {
        let c = comps[idx]
        let json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as! ComponentCell
        cell.setCellName("ACCU")
        cell.lbl.attributedText = NSAttributedString(string: json["name"].asString!, attributes: [NSKernAttributeName:4])
        //cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImageAccu(idx))
        cell.imgBanner(setBannerAccu(idx))
        
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func setBannerAccu(idx: Int) ->[String] {
        var bannerImages: [String] = []
        
        let component_data: JSON = states.getObudataByIdState(33)
        if (component_data.length > 0) {
            let component_value: String = component_data["value"].asString!
        
            if (component_value == "1") {
                let component_data30: JSON = states.getObudataByIdState(30)
                let component_data31: JSON = states.getObudataByIdState(31)
                let component_data32: JSON = states.getObudataByIdState(32)

                if (component_data30.length > 0) {
                    bannerImages.append(states.toDecimal(component_data30["value"].asString!, decimals: 0)+"%")
                } else {
                    bannerImages.append(states.dblSpace("NA %"))
                }
                
                if (component_data31.length > 0) {
                    bannerImages.append(states.toDecimal(component_data31["value"].asString!, decimals: 2)+"A")
                } else {
                    bannerImages.append(states.dblSpace("NA A"))
                }
                
                if (component_data32.length > 0) {
                    bannerImages.append(states.toDecimal(component_data32["value"].asString!, decimals: 2)+"V")
                } else {
                    bannerImages.append(states.dblSpace("NA V"))
                }

            }
        }
        return bannerImages
    }
    
    func setImageAccu(idx: Int) ->[UIImage] {
        var compImages: [UIImage] = []
        let component_data: JSON = states.getObudataByIdState(33)
        if (component_data.length > 0) {
            let component_value: String = component_data["value"].asString!
            if (component_value == "0") {
                compImages.append(UIImage(named: "ic_accu_disconnected")!)
            }
        }
        
        /*if (compImages.count == 0) {
            compImages.append(UIImage(named: "ic_ok")!)
        }*/
        return compImages
    }
    
    func alarmCellAccu(json: JSON) ->Bool {
        //let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        //for component_state in component_states {
            let component_data1: JSON = states.getObudataByIdState(33)
            if (component_data1.length > 0) {
                if (Int((component_data1["value"].asString)!) == 0) {
                    setAlarm(json["id_component"].asInt!)
                    return true
                }
            }
        //}
        //for component_state in component_states {
            let component_data2: JSON = states.getObudataByIdState(34)
            if (component_data2.length > 0) {
                if (Int((component_data2["value"].asString)!) == 1) {
                    setAlarm(json["id_component"].asInt!)
                    return true
                }
            }
        //}
        return false
    }
   
    /**
    * LIGHT
    */
    func renderCellLight(idx: Int, tableView: UITableView) ->UITableViewCell {
        let c = comps[idx]
        let json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as! ComponentCell
        cell.setCellName("LIGHT")
        cell.lbl.attributedText = NSAttributedString(string: json["name"].asString!, attributes: [NSKernAttributeName:4])
        //cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImageLight(idx))
        cell.imgBanner([])
        
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func setImageLight(idx: Int) ->[UIImage] {
        var compImages: [UIImage] = []
        let component_data: JSON = states.getObudataByIdState(50)
        if (component_data.length > 0) {
            let component_value: String = component_data["value"].asString!
        
            if (component_value == "0") {
                compImages.append(UIImage(named: "ic_light_grey")!)
            } else if (component_value == "1") {
                compImages.append(UIImage(named: "ic_light_green")!)
            }
        }
        
        if (compImages.count == 0) {
            compImages.append(UIImage(named: "ic_light_grey")!)
        }
        return compImages
    }
    
    func alarmCellLight(json: JSON) ->Bool {
        return false
    }
    
    /**
    * FAN
    */
    func renderCellFan(idx: Int, tableView: UITableView) ->UITableViewCell {
        let c = comps[idx]
        let json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as! ComponentCell
        cell.setCellName("FAN")
        cell.lbl.attributedText = NSAttributedString(string: json["name"].asString!, attributes: [NSKernAttributeName:4])
        //cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImageFan(idx))
        cell.imgBanner([])
        
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func setImageFan(idx: Int) ->[UIImage] {
        var compImages: [UIImage] = []
        let component_data: JSON = states.getObudataByIdState(60)
        if (component_data.length > 0) {
            let component_value: String = component_data["value"].asString!
        
            if (component_value == "0") {
                compImages.append(UIImage(named: "ic_fan_grey")!)
            } else if (component_value == "1") {
                compImages.append(UIImage(named: "ic_fan_green")!)
            }
        }

        if (compImages.count == 0) {
            compImages.append(UIImage(named: "ic_fan_grey")!)
        }
        return compImages
    }
    
    func alarmCellFan(json: JSON) ->Bool {
        return false
    }
    
    /**
    * DOOR
    */
    func renderCellDoor(idx: Int, tableView: UITableView) ->UITableViewCell {
        let c = comps[idx]
        let json = c.json
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComponentCell") as! ComponentCell
        cell.setCellName("DOOR")
        cell.lbl.attributedText = NSAttributedString(string: json["name"].asString!, attributes: [NSKernAttributeName:4])
        //cell.lbl.text = states.dblSpace(json["name"].asString!)
        cell.imgAnimate(setImageDoor(idx))
        cell.imgBanner([])
        
        if (c.alarm) {
            cell.onCellAnimation()
        } else {
            cell.offCellAnimation()
        }
        return cell
    }
    
    func setImageDoor(idx: Int) ->[UIImage] {
        var compImages: [UIImage] = []
        let component_data: JSON = states.getObudataByIdState(70)
        if (component_data.length > 0) {
            let component_value: String = component_data["value"].asString!
        
            if (component_value == "0") {
                compImages.append(UIImage(named: "ic_door_green")!)
            } else if (component_value == "1") {
                compImages.append(UIImage(named: "ic_door_red")!)
            }
        }

        if (compImages.count == 0) {
            compImages.append(UIImage(named: "ic_door_grey")!)
        }
        return compImages
    }
    
    func alarmCellDoor(json: JSON) ->Bool {
        let component_states: [JSON] = states.getComponentStates(json["id_component"].asInt!)
        for component_state in component_states {
            let component_data: JSON = states.getObudataByIdState(70)
            if (component_data.length > 0) {
                if (Int((component_data["value"].asString)!) == 1) {
                    setAlarm(json["id_component"].asInt!)
                    return true
                }
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
        let valuesArr = values.characters.split {$0 == ","}.map { String($0) }

        for value in valuesArr {
            if (Int((jdata["value"].asString)!) == Int(value)) {
                return true
            }
        }
        return false
    }
}

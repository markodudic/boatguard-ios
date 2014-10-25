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
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        
        cell.textLabel.text = json["name"].asString
        cell.detailTextLabel?.text = json["value"].asString
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        
        return cell
    }
    
    func renderCellPump(json: JSON) ->UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel.text = json["name"].asString
        
        let data: JSON = states.getObudataBystate(json["id_component"].asInt!)
        cell.detailTextLabel?.text = data["value"].asString
        cell.imageView.image = UIImage(named: "ic_pump")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        
        return cell
    }
    
    func renderCellAnchor(json: JSON) ->UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel.text = json["name"].asString
        
        let data: JSON = states.getObudataBystate(json["id_component"].asInt!)
        println(data)
        cell.detailTextLabel?.text = data["value"].asString
        cell.imageView.image = UIImage(named: "ic_anchor")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }
    
    func renderCellGeo(json: JSON) ->UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel.text = json["name"].asString
        
        let data: JSON = states.getObudataBystate(json["id_component"].asInt!)
        cell.detailTextLabel?.text = data["value"].asString
        cell.imageView.image = UIImage(named: "ic_geo")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }
    
    func renderCellAccu(json: JSON) ->UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel.text = json["name"].asString
        
        let data: JSON = states.getObudataBystate(json["id_component"].asInt!)
        cell.detailTextLabel?.text = data["value"].asString
        cell.imageView.image = UIImage(named: "ic_accu")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }
}
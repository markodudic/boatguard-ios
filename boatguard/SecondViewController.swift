//
//  SecondViewController.swift
//  boatguard
//
//  Created by bl4z on 10/09/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblDashboard: UITableView!
    @IBOutlet var lblRefresh: UILabel!
    var obucomponentsOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblRefresh.text = "LAST UPDATE: "+states.getObudatadateTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.countVisibleObucomponents()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var json = states.getObucomponent(indexPath.row+obucomponentsOffset)

        //skip nonvisible
        if (json["show"].asInt == 0) {
            obucomponentsOffset++
            json = states.getObucomponent(indexPath.row+obucomponentsOffset)
        }
        
        if (json["type"].asString == "PUMP") {
            return renderCellPump(json)
        } else if (json["type"].asString == "ANCHOR") {
            return renderCellAnchor(json)
        } else if (json["type"].asString == "GEO") {
            return renderCellGeo(json)
        } else if (json["type"].asString == "ACCU") {
            return renderCellAccu(json)
        }
        
        //unknown
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")

        cell.textLabel?.text = json[indexPath.row]["name"].asString
        cell.detailTextLabel?.text = json["value"].asString
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }
    
    func renderCellPump(json: JSON) ->UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel?.text = json["name"].asString
        
        let data: JSON = states.getObudataBystate(json["id_component"].asInt!)
        cell.detailTextLabel?.text = data["value"].asString
        cell.imageView?.image = UIImage(named: "ic_pump")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }

    func renderCellAnchor(json: JSON) ->UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel?.text = json["name"].asString
        
        let data: JSON = states.getObudataBystate(json["id_component"].asInt!)
        println(data)
        cell.detailTextLabel?.text = data["value"].asString
        cell.imageView?.image = UIImage(named: "ic_anchor")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }

    func renderCellGeo(json: JSON) ->UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel?.text = json["name"].asString
        
        let data: JSON = states.getObudataBystate(json["id_component"].asInt!)
        cell.detailTextLabel?.text = data["value"].asString
        cell.imageView?.image = UIImage(named: "ic_geo")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }

    func renderCellAccu(json: JSON) ->UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel?.text = json["name"].asString
        
        let data: JSON = states.getObudataBystate(json["id_component"].asInt!)
        cell.detailTextLabel?.text = data["value"].asString
        cell.imageView?.image = UIImage(named: "ic_accu")
        cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.888), blue: CGFloat(0.886), alpha: CGFloat(1))
        return cell
    }

}


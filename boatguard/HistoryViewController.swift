//
//  HistoryViewController.swift
//  boatguard
//
//  Created by Marko Dudic on 5/21/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var viewHistory: UIView!
    @IBOutlet var tableView: UITableView!
    
    var historyStates:JSON!
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //add gradients
        let gl = CAGradientLayer()
        gl.colors = [settings.gradientTop, settings.gradientBottom]
        gl.locations = [0.0, 1.0]
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewHistory.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewHistory.layer.frame.width,30)
            
        }
        viewHistory.layer.insertSublayer(gl, atIndex: 999)
        
        historyStates = states.history["states"];
    }
    
    
    //history
    func refreshHistory() {
        let historyURL  = settings.historyUri+"?obuid="+String(states.getObuid())
        let historyJSON  = Comm.JSONfromURL(historyURL)
        states.setHistory(historyJSON)
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.refreshHistory()
        })
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyStates.length;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //println(indexPath.row)
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell") as! HistoryCell
        var historyString = historyStates[indexPath.row][0]["dateState"].asString! + " "
        var anchor = false
        
        var state = historyStates[indexPath.row];
        for (i, v) in state {
            var idState = v["id_state"].asInt!
            switch idState {
                case 10:
                    if v["value"].asInt == 0 {
                        cell.imgGeoFence(UIImage(named: "ic_geo_grey")!)
                    }
                    else if v["value"].asInt == 1 {
                        cell.imgGeoFence(UIImage(named: "ic_geo_green")!)
                    }
                    else {
                        cell.imgGeoFence(UIImage(named: "ic_geo_red")!)
                    }
                case 20:
                    if v["value"].asInt == 0 {
                        cell.imgBilgePump(UIImage(named: "ic_ok")!)
                    }
                    else if v["value"].asInt == 1 {
                        cell.imgBilgePump(UIImage(named: "ic_pump_1_9")!)
                    }
                    else if v["value"].asInt == 2 {
                        cell.imgBilgePump(UIImage(named: "ic_pump_2")!)
                    }
                    else if v["value"].asInt == 3 {
                        cell.imgBilgePump(UIImage(named: "ic_pump_3")!)
                    }
                    else {
                        cell.imgBilgePump(UIImage(named: "ic_pump_4")!)
                    }
                case 40:
                    anchor = true
                    if v["value"].asInt == 0 {
                        cell.imgAnchor(UIImage(named: "ic_anchor_grey")!)
                        anchor = false
                    }
                case 41:
                    if anchor {
                        if v["value"].asInt == 0 {
                            cell.imgAnchor(UIImage(named: "ic_anchor_green")!)
                        }
                        else {
                            cell.imgAnchor(UIImage(named: "ic_anchor_red")!)
                        }
                    }
                case 30:
                    historyString += v["value"].asString! + "% "
                case 31:
                    historyString += v["value"].asString! + "A "
                case 32:
                    historyString += v["value"].asString! + "V "
                case 34:
                    if v["value"].asInt == 1 {
                        cell.imgBattery(UIImage(named: "ic_accu_disconnected")!)
                    }
                    else {
                        cell.imgBattery(UIImage(named: "ic_ok")!)               
                    }
                default: print("")
            }
        }
        
        
        cell.lbl.text = historyString
        cell.userInteractionEnabled = false
        return cell
    }
   

}

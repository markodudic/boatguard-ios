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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblRefresh.text = "LAST UPDATE: "+states.getObudatadateTime()

        //anim thread
        /*
        Async.background {
            while(true) {
                sleep(5)
                self.spawnCellAnimation()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tblDashboard.reloadData()
                })
            }
        }
        */
    }
    
    func onCellAnimation(cell: UITableViewCell) {
        UIView.animateWithDuration(2, animations: {
            cell.backgroundColor = UIColor(red: CGFloat(0.753), green: CGFloat(0.255), blue: CGFloat(0.106), alpha: CGFloat(1))
            }, completion: {
                (value: Bool) in
                self.offCellAnimation(cell)
        })
    }
    
    func offCellAnimation(cell: UITableViewCell) {
        UIView.animateWithDuration(2, animations: {
            cell.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.886), blue: CGFloat(0.886), alpha: CGFloat(1))
            }, completion: {
                (value: Bool) in
                self.onCellAnimation(cell)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.getComponentsCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let comp = components.getComponent(indexPath.row)
        if (comp.alarm) {
            self.onCellAnimation(comp.cell)
        }
        return comp.cell
    }
}
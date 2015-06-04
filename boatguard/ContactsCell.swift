//
//  ContactsCell.swift
//  boatguard
//
//  Created by Marko Dudic on 6/3/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var customerId: Int = 0
    var table: UITableView!

    func imgTap(tableView: UITableView, uid: Int) {
        customerId = uid
        table = tableView
        //event
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        
        img.userInteractionEnabled = true
        img.addGestureRecognizer(recognizer)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        states.deleteFriend(customerId)
        Comm.HTTPPostJSON(settings.friendsSetUri, jsonObj: states.friends.toString(pretty: false))
        table.reloadData()
    }
}

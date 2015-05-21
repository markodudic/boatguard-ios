//
//  HistoryCell.swift
//  boatguard
//
//  Created by Marko Dudic on 5/21/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var imgGeoFence: UIImageView!
    @IBOutlet weak var imgAnchor: UIImageView!
    @IBOutlet weak var imgBilgePump: UIImageView!
    @IBOutlet weak var imgBattery: UIImageView!
   
    func imgGeoFence(img: UIImage) {
        imgGeoFence.image = img
        imgGeoFence.clipsToBounds = true
        imgGeoFence.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    func imgAnchor(img: UIImage) {
        imgAnchor.image = img
        imgAnchor.clipsToBounds = true
        imgAnchor.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    func imgBilgePump(img: UIImage) {
        imgBilgePump.image = img
        imgBilgePump.clipsToBounds = true
        imgBilgePump.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    func imgBattery(img: UIImage) {
        imgBattery.image = img
        imgBattery.clipsToBounds = true
        imgBattery.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
}

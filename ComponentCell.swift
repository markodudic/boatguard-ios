//
//  ComponentCell.swift
//  boatguard
//
//  Created by bl4z on 17/11/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit

class ComponentCell: UITableViewCell {


    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
 
    
    func onCellAnimation() {
        UIView.animateWithDuration(2, animations: {
            self.backgroundColor = UIColor(red: CGFloat(0.753), green: CGFloat(0.255), blue: CGFloat(0.106), alpha: CGFloat(1))
            }, completion: {
                (value: Bool) in
                self.offCellAnimation()
        })
    }
    
    func offCellAnimation() {
        UIView.animateWithDuration(2, animations: {
            self.backgroundColor = UIColor(red: CGFloat(0.886), green: CGFloat(0.886), blue: CGFloat(0.886), alpha: CGFloat(1))
            }, completion: {
                (value: Bool) in
                self.onCellAnimation()
        })
    }
}

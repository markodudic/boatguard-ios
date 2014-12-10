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
    @IBOutlet weak var view: UIView!
    
    var compImages: [UIImage] = []
   
    func imgAnimate(imgs: [UIImage]) {
        compImages = imgs
        img.image = compImages.last

        let options = (UIViewAnimationOptions.Repeat)
        UIView.animateWithDuration(1.0, delay: 0.0, options: options,
            animations: {
                for i in self.compImages {
                    println(i)
                    self.img.image = i
                }
            }, completion: {
                (value: Bool) in
        })
    }
    
    func onCellAnimation() {
        let options = (UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.Repeat)
        UIView.animateWithDuration(2.0, delay: 0.0, options: options,
            animations: {
                self.view.layer.backgroundColor = settings.cellAlarm.CGColor
                self.view.layer.backgroundColor = settings.cellNormal.CGColor
            }, completion: {
                (value: Bool) in
            })
   
    }
    
    func offCellAnimation() {
        view.layer.removeAllAnimations()
        self.view.layer.backgroundColor = settings.cellNormal.CGColor
    }
}

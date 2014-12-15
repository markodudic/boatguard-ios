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
        
        if (compImages.count > 1) {
            let anim = UIImageView(image: compImages.first)
            anim.animationImages = compImages
            anim.animationDuration = 2
            anim.startAnimating()
            img.addSubview(anim)
        } else {
            img.image = compImages.first
        }
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
        view.layer.backgroundColor = settings.cellNormal.CGColor
    }
}

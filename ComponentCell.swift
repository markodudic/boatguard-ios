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
    @IBOutlet weak var bnr: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var subviewtop: UIView!
    @IBOutlet weak var subviewbottom: UIView!
    
    var compImages: [UIImage] = []
    var name: String = "UNKNOWN"

    var componentAccuIdx: Int = 0
    var componentAccuBanner: [String] = []
    
    func setName(n: String) {
        name = n
    }
    
    func imgAnimate(imgs: [UIImage]) {
        compImages = imgs

        //remove existing subviews
        for view in img.subviews {
            view.removeFromSuperview()
        }
        
        let anim = UIImageView(image: compImages.first)
        if (compImages.count > 0) {
            anim.animationImages = compImages
            anim.animationDuration = 2
            anim.startAnimating()
        }
        img.addSubview(anim)
    }
    
    func imgBanner(banner: [String]) {
        //event
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        
        //no component banner
        if (banner.count == 0) {
            bnr.hidden = true
            self.userInteractionEnabled = false
            return
        }
        
        bnr.hidden = false
        self.userInteractionEnabled = true
        self.addGestureRecognizer(recognizer)
        
        //showbanner
        if (name == "ACCU") {
            componentAccuIdx = 0
            componentAccuBanner = banner
        }
        handleComponentBanner()
    }

    func handleTap(recognizer: UITapGestureRecognizer) {
        //shownextbanner
        if (name == "ACCU") {
            componentAccuIdx++
            if (componentAccuIdx > 2) {
                componentAccuIdx = 0
            }
        }
        handleComponentBanner()
    }
    
    func onCellAnimation() {
        //show gradiente
        subviewtop.hidden = false
        subviewbottom.hidden = false
        subviewtop.backgroundColor = UIColor.clearColor()
        subviewbottom.backgroundColor = UIColor.clearColor()

        let gl_top = CAGradientLayer()
        gl_top.colors = [settings.gradientTop, settings.gradientBottom]
        gl_top.locations = [0.0, 1.0]
        gl_top.frame = CGRectMake(0,0,320,10)
        subviewtop.layer.insertSublayer(gl_top, atIndex: 0)
        
        let gl_bottom = CAGradientLayer()
        gl_bottom.colors = [settings.gradientBottom, settings.gradientTop]
        gl_bottom.locations = [0.0, 1.0]
        gl_bottom.frame = CGRectMake(0,0,320,10)
        subviewbottom.layer.insertSublayer(gl_bottom, atIndex: 0)
        
        let options = (UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.Repeat)
        UIView.animateWithDuration(2.0, delay: 0.0, options: options,
            animations: {
                self.view.layer.backgroundColor = settings.cellAlarm.CGColor
                self.view.layer.backgroundColor = settings.cellNormal.CGColor
            }, completion: {
                (value: Bool) in
            }
        )
    }
    
    func offCellAnimation() {
        //hide gradiente
        subviewtop.hidden = true
        subviewbottom.hidden = true
        
        view.layer.removeAllAnimations()
        view.layer.backgroundColor = settings.cellNormal.CGColor
    }
    
    func handleComponentBanner() {
        //remove existing subviews
        for view in img.subviews {
            view.removeFromSuperview()
        }

        if (name == "ACCU") {
            let anim = UIImageView(image: UIImage(named: "ic_bnr_"+String(componentAccuIdx)))
            img.addSubview(anim)
            bnr.text = componentAccuBanner[componentAccuIdx]
            bnr.textColor = settings.lblGreen
            
            if (componentAccuIdx == 0) {
                let component_data: JSON = states.getObudataByIdState(34)
                let component_value: String = component_data["value"].asString!
                
                if (component_value == "1") {
                    bnr.textColor = settings.lblRed
                }
            }
        }
    }
}

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
            //componentAccuIdx = 0
            componentAccuBanner = banner
            handleComponentAccuBanner()
        }
    }

    func handleTap(recognizer: UITapGestureRecognizer) {
        //shownextbanner
        if (name == "ACCU") {
            componentAccuIdx++
            if (componentAccuIdx > 2) {
                componentAccuIdx = 0
            }
            handleComponentAccuBanner()
        }
    }
    
    func onCellAnimation() {
        //show gradients
        subviewtop.hidden = false
        subviewbottom.hidden = false
        subviewtop.backgroundColor = UIColor.clearColor()
        subviewbottom.backgroundColor = UIColor.clearColor()
        
        let options = (UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.Repeat)

        let gl_top = CAGradientLayer()
        gl_top.colors = [settings.gradientTop_a, settings.gradientBottom_a]
        gl_top.locations = [0.0, 1.0]
        gl_top.frame = CGRectMake(0,0,320,15)
        subviewtop.layer.insertSublayer(gl_top, atIndex: 0)

        let gl_bottom = CAGradientLayer()
        gl_bottom.colors = [settings.gradientBottom_a, settings.gradientTop_a]
        gl_bottom.locations = [0.0, 1.0]
        gl_bottom.frame = CGRectMake(0,-5,320,15)
        subviewbottom.layer.insertSublayer(gl_bottom, atIndex: 0)

        UIView.animateWithDuration(2.0, delay: 0.0, options: options,
            animations: {
                self.subviewbottom.alpha = 0.2
                self.subviewbottom.alpha = 0.0
            }, completion: {
                (value: Bool) in
            }
        )

        UIView.animateWithDuration(2.0, delay: 0.0, options: options,
            animations: {
                self.subviewtop.alpha = 0.2
                self.subviewtop.alpha = 0.0
            }, completion: {
                (value: Bool) in
            }
        )
        
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
        //hide gradients
        subviewtop.hidden = true
        subviewtop.layer.removeAllAnimations()
        subviewbottom.hidden = true
        subviewbottom.layer.removeAllAnimations()
        
        view.layer.removeAllAnimations()
        view.layer.backgroundColor = settings.cellNormal.CGColor
    }
    
    func handleComponentAccuBanner() {
        //remove existing subviews
        for view in img.subviews {
            view.removeFromSuperview()
        }

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

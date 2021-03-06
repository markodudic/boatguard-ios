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
    
    func setCellName(n: String) {
        name = n
    }
    
    func imgAnimate(imgs: [UIImage]) {
        compImages = imgs

        //remove existing subviews
        for view in img.subviews {
            view.removeFromSuperview()
        }
        
        img.image = compImages.first
        //let anim = UIImageView(image: compImages.first)
        if (compImages.count > 0) {
            img.animationImages = compImages
            img.animationDuration = 2
            img.startAnimating()
        }
        img.clipsToBounds = true
        img.contentMode = UIViewContentMode.ScaleAspectFit
        //img.addSubview(anim)
    }
    
    func imgBanner(banner: [String]) {
        //event
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        
        //no component banner
        if (banner.count == 0) {
            bnr.hidden = true
            bnr.userInteractionEnabled = false
            return
        }
        
        bnr.hidden = false
        bnr.userInteractionEnabled = true
        bnr.addGestureRecognizer(recognizer)
        
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
        
        let gl_top = CAGradientLayer()
        gl_top.colors = [settings.gradientTop_a, settings.gradientBottom_a]
        gl_top.locations = [0.0, 1.0]
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl_top.frame = CGRectMake(0,0,self.layer.frame.width,15)
        }
        else {
            gl_top.frame = CGRectMake(0,0,self.layer.frame.width,30)
            
        }
        subviewtop.layer.insertSublayer(gl_top, atIndex: 0)

        let gl_bottom = CAGradientLayer()
        gl_bottom.colors = [settings.gradientBottom_a, settings.gradientTop_a]
        gl_bottom.locations = [0.0, 1.0]
        if idiom == UIUserInterfaceIdiom.Phone {
            gl_bottom.frame = CGRectMake(0,-5,self.layer.frame.width,15)
        }
        else {
            gl_bottom.frame = CGRectMake(0,0,self.layer.frame.width,30)
            
        }
        subviewbottom.layer.insertSublayer(gl_bottom, atIndex: 0)

        let options: UIViewAnimationOptions = ([UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.Repeat, UIViewAnimationOptions.AllowUserInteraction])

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

        //let anim = UIImageView(image: UIImage(named: "ic_bnr_"+String(componentAccuIdx)))
        img.image = UIImage(named: "ic_bnr_"+String(componentAccuIdx))
        img.clipsToBounds = true
        img.contentMode = UIViewContentMode.ScaleAspectFit
        //img.addSubview(anim)
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            img.frame = CGRect(x: img.frame.origin.x, y: bnr.frame.origin.y+15, width: img.frame.size.width, height: img.frame.size.height)
        }
        else {
            img.frame = CGRect(x: img.frame.origin.x, y: bnr.frame.origin.y+30, width: img.frame.size.width, height: img.frame.size.height)
        }
        bnr.text = componentAccuBanner[componentAccuIdx]
        bnr.textColor = settings.lblGreen
            
        if (componentAccuIdx == 0) {
            let component_data: JSON = states.getObudataByIdState(34)
            if (component_data.length > 0) {
                let component_value: String = component_data["value"].asString!
                
                if (component_value == "1") {
                    bnr.textColor = settings.lblRed
                }
            }
        }
    }
}

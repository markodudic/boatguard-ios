//
//  GeoFenceController.swift
//  boatguard
//
//  Created by Marko Dudic on 3/20/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import UIKit

class GeoFenceViewController: UIViewController {
    
    @IBOutlet var viewGeoFence: UIView!
    
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
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewGeoFence.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewGeoFence.layer.frame.width,30)
            
        }
        viewGeoFence.layer.insertSublayer(gl, atIndex: 999)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}

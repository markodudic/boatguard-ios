//
//  Tab.swift
//  boatguard
//
//  Created by bl4z on 12/01/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//
import UIKit

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set toolbar highlighting color
        self.tabBar.tintColor = UIColor(red: CGFloat(0.607843), green: CGFloat(0.607843), blue: CGFloat(0.607843), alpha: CGFloat(1))
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.selectedIndex = 1
        var tabFrame: CGRect = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            tabFrame.size.height = 60;
            tabFrame.origin.y = self.view.frame.size.height - 60;
        }
        else {
            tabFrame.size.height = 120;
            tabFrame.origin.y = self.view.frame.size.height - 120;
        }
        self.tabBar.frame = tabFrame;
        
        let third = tabFrame.size.width/3
        let line_height = tabFrame.size.height/2
        let line_offset = tabFrame.size.height/4
        
        //add vertical lines
        let imageSize = CGSize(width: 1, height: line_height)
        let imageView1 = UIImageView(frame: CGRect(origin: CGPoint(x: third*1, y: line_offset), size: imageSize))
        let imageView2 = UIImageView(frame: CGRect(origin: CGPoint(x: third*2, y: line_offset), size: imageSize))
        
        imageView1.image = drawCustomImage(imageSize)
        imageView2.image = drawCustomImage(imageSize)
        
        self.tabBar.addSubview(imageView1)
        self.tabBar.addSubview(imageView2)
        
    }
 
    
    func drawCustomImage(size: CGSize) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, settings.gradientTop)
        CGContextSetLineWidth(context, 1.0)
        
        CGContextStrokeRect(context, bounds)
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
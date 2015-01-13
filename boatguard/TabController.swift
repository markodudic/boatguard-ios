//
//  Tab.swift
//  boatguard
//
//  Created by bl4z on 12/01/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//
import UIKit

class TabController: UITabBarController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        var tabFrame: CGRect = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
        tabFrame.size.height = 100;
        tabFrame.origin.y = self.view.frame.size.height - 100;
        self.tabBar.frame = tabFrame;
        
        var third = tabFrame.size.width/3
        var line_height = tabFrame.size.height/2
        var line_offset = tabFrame.size.height/4
        
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
        let bounds = CGRect(origin: CGPoint.zeroPoint, size: size)
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
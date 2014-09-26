//
//  ThirdViewController.swift
//  boatguard
//
//  Created by bl4z on 10/09/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit
import MapKit

class ThirdViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var theMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var json = states.getObudata()
        var sLat:String = ""
        var sLon:String = ""
        
        for (i, v) in json["states"] {
            
            println(v)
            if (v["id_state"].asInt == 11) {
                sLon = v["value"].asString!
            } else if (v["id_state"].asInt == 12) {
                sLat = v["value"].asString!
            }
        }
        
        var lat:CLLocationDegrees = Double((sLat as NSString).doubleValue)/100 //45.506
        var lon:CLLocationDegrees = Double((sLon as NSString).doubleValue)/100 //13.596
        
        var latDelta:CLLocationDegrees = 0.5
        var lonDelta:CLLocationDegrees = 0.5
        
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var boatLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(boatLocation, theSpan)
        
        theMapView.setRegion(theRegion, animated: true)
        
        var theBoatLocation = MKPointAnnotation()
        theBoatLocation.coordinate = boatLocation
        
        var loginJSON = states.getLogin()
        theBoatLocation.title = loginJSON["obu"]["name"].asString!
        theMapView.addAnnotation(theBoatLocation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


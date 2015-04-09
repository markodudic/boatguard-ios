//
//  ThirdViewController.swift
//  boatguard
//
//  Created by bl4z on 10/09/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit
import MapKit
import Darwin

class ThirdViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var theMapView: MKMapView!
    @IBOutlet var imgLogo: UIImageView!
    
    @IBOutlet var viewMap: UIView!
    
    //Events
    @IBAction func btnBack_click(sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
        self.tabBarController?.tabBar.hidden = false
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        //add gradients
        let gl = CAGradientLayer()
        gl.colors = [settings.gradientTop, settings.gradientBottom]
        gl.locations = [0.0, 1.0]
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl.frame = CGRectMake(0,0,viewMap.layer.frame.width,10)
        }
        else {
            gl.frame = CGRectMake(0,0,viewMap.layer.frame.width,30)
            
        }
        viewMap.layer.insertSublayer(gl, atIndex: 999)
    }
    
    func addCircle(location: CLLocation, radius: CLLocationDistance){
        self.theMapView.delegate = self
        var circle = MKCircle(centerCoordinate: location.coordinate, radius: radius)
        self.theMapView.addOverlay(circle)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            anView.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as CustomPointAnnotation
        anView.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        
        var json = states.getObudata()
        var sLat:String = ""
        var sLon:String = ""
        
        for (i, v) in json["states"] {
            if (v["id_state"].asInt == 11) {
                sLon = v["value"].asString!
            } else if (v["id_state"].asInt == 12) {
                sLat = v["value"].asString!
            }
        }
        
        var lat:CLLocationDegrees = Double((sLat as NSString).doubleValue)/100 //45.506
        var lon:CLLocationDegrees = Double((sLon as NSString).doubleValue)/100 //13.596
        
        var lat_f = floor(lat)
        var lon_f = floor(lon)
        
        var lat_left = lat-lat_f
        var lon_left = lon-lon_f
        
        lat_left = lat_left*100/60
        lon_left = lon_left*100/60
        
        lat = lat_f + lat_left
        lon = lon_f + lon_left
        
        var latDelta:CLLocationDegrees = 0.04
        var lonDelta:CLLocationDegrees = 0.04
        
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var boatLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(boatLocation, theSpan)
        
        theMapView.delegate = self
        theMapView.setRegion(theRegion, animated: true)
        theMapView.showsUserLocation = true
        
        var theBoatLocation = CustomPointAnnotation()
        theBoatLocation.coordinate = boatLocation
        var loginJSON = states.getLogin()
        theBoatLocation.title = loginJSON["obu"]["name"].asString!
        theBoatLocation.subtitle = states.getObudatadateTime()
        theBoatLocation.imageName = "geo_marker"
        theMapView.addAnnotation(theBoatLocation)

        theMapView.removeOverlays(theMapView.overlays)
        var location = CLLocation(latitude: lat as CLLocationDegrees, longitude: lon as CLLocationDegrees)
        if (states.getObuSettingsByIdState(10)["value"].asString! == "1"){
            var distance = (states.getObuSettingsByIdState(13)["value"].asString! as NSString).doubleValue
            addCircle(location, radius: distance as CLLocationDistance)
        }
        
        if (states.getObuSettingsByIdState(40)["value"].asString! == "1"){
            var distance = (states.getObuSettingsByIdState(41)["value"].asString! as NSString).doubleValue
            addCircle(location, radius: distance as CLLocationDistance)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
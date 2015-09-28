//
//  Comm.swift
//  boatguard
//
//  Created by Marko Dudic on 4/8/15.
//  Copyright (c) 2015 bl4z. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

public class Comm {
    
    public class func JSONfromURL(var uri: String) ->JSON {
        if (isConnectedToNetwork() == true)
        {
            if (uri.rangeOfString("?") == nil) {
                uri += "?sesionid="+states.getSessionId()
            }
            else {
                uri += "&sesionid="+states.getSessionId()
            }
            //println(uri)
            return JSON.fromURL(uri)
        }
        else
        {
            let error = "{\"obu\":\"\",\"sessionId\":\"\",\"error\":{\"name\":\"Internet connection\",\"code\":\"1\",\"msg\":\"There is no internet connection. Enable it.\"}}"
            
            return JSON(string: error)
        }
    }
    
    public class func HTTPPostJSON(var url: String, jsonObj: String) {
        //println(isConnectedToNetwork())
        if (isConnectedToNetwork() == true)
        {
            if (url.rangeOfString("?") == nil) {
                url += "?sesionid="+states.getSessionId()
            }
            else {
                url += "&sesionid="+states.getSessionId()
            }

            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let data: NSData = jsonObj.dataUsingEncoding(NSUTF8StringEncoding)!
            request.HTTPBody = data
            HTTPsendRequest(request)
        }
        else
        {
            let alert = UIAlertView()
            alert.title = "Internet connection"
            alert.message = "There is no internet connection. Enable it."
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    public class func HTTPsendRequest(request: NSMutableURLRequest) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(
            request,
            completionHandler: {
                data, response, error in
                /*if error != nil {
                callback("", error.localizedDescription)
                } else {
                callback(
                NSString(data: data, encoding: NSUTF8StringEncoding)!,
                nil
                )
                }*/
        })
        
        task.resume()
    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

}
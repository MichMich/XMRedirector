//
//  Api.swift
//  XMRedirector
//
//  Created by Michael Teeuw on 23/09/14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import Foundation





struct Config {
    static let baseURL = "http://office.xonay.net:8080/api/"
    static let queueName = "nl.xonaymedia.xmredirector.api"
}

class Api {
    
    var deviceIdentifier = ""
    
    class var sharedInstance : Api {
        struct Static {
            static let instance : Api = Api()
        }
        return Static.instance
    }
    
    //+ (void)performRequestWithUri:(NSString *)requestUri params:(NSDictionary *)params completionHandler:(void (^)(NSDictionary *, NSError *))completionBlock
    
    
    func performRequestWithUri(uri:String, completionHandler:(json:JSON?, error:NSError?)->()) {
        
        var url = Config.baseURL + uri.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        //add the device identifier.
        url = url + "?deviceIdentifier=" + self.deviceIdentifier.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        
        println(url)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        
        let queue = NSOperationQueue()
        queue.name = Config.queueName

        

        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) {
            (response, data, error) -> Void  in
    
            
            //Check if there was an error ...
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in
                    completionHandler(json: nil, error: error)
                })
                return
            }
            
            
            let json = JSON(data: data)

            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                completionHandler(json: json, error: nil)
            })

            
    
            
        }
        
        
    }
    

    
    
}



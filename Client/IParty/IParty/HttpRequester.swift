//
//  HttpRequester.swift
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

import Foundation

@objc class HttpRequester: NSObject {
    
    func post(atUrl url: String, withFormDataData data: String, andCustomHeaders customHeaders: [String: String]?, completion: (NSString?, NSNumber?) -> ()) {
        
        let request = createRequest(withUrl: url, andCustomHeaders: customHeaders);
        
        request.HTTPMethod = "POST";
        let postString = data;
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        executeRequestAsync(request, completion: completion);
    }
    
    func uploadFile(atUrl url: String, withFileData data: NSData?, boundary: NSString?, mimetype: NSString?, andCustomHeaders customHeaders: [String: String]?, completion: (NSString?, NSNumber?) -> ()) {
    
        let request = createRequest(withUrl: url, andCustomHeaders: customHeaders);
        
        request.HTTPMethod = "POST";
        
        let filePathKey = "unknown";
        let filename = "unknown";
        let myBounday = "ipartyyoupartywepartytheyparty";
        
        let body = NSMutableData()
        body.appendData("--\(myBounday)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(data!)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(myBounday)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body;
        
        executeRequestAsync(request, completion: completion);
    }
    
    func get(atUrl url: String, withCustomHeaders customHeaders: [String: String]?, completion: (NSString?, NSNumber?) -> ()) {
    
        let request = createRequest(withUrl: url, andCustomHeaders: customHeaders);
    
        request.HTTPMethod = "GET";
        
        executeRequestAsync(request, completion: completion);
    }

    func createRequest(withUrl url: String, andCustomHeaders customHeaders: [String: String]?) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!);
        
        request.setValue("localhost", forHTTPHeaderField: "Host");
        
        if(customHeaders != nil) {
            for (headerName, headerValue) in customHeaders! {
                request.setValue(headerValue, forHTTPHeaderField: headerName);
            }
        }
        
        return request;
    }
    
    func executeRequestAsync(request: NSMutableURLRequest, completion: (NSString?, NSNumber?) -> ()) {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else { // check for networking error
                completion(nil, nil);
                return
            }
            
            let httpStatus = response as? NSHTTPURLResponse;
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            completion(responseString!, httpStatus!.statusCode);
        }
        task.resume()
    }
}
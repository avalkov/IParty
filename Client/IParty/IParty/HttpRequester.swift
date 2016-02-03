//
//  HttpRequester.swift
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

import Foundation

@objc class HttpRequester: NSObject {
    
    func post(atUrl url: String, withFormDataData data: String, completion: (NSString?, NSNumber?) -> ()) {
        
        let request = createRequest(withUrl: url);
        
        request.HTTPMethod = "POST";
        let postString = data;
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                completion(nil, nil);
                return
            }
            
            let httpStatus = response as? NSHTTPURLResponse;
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            completion(responseString!, httpStatus!.statusCode);
        }
        task.resume()
    }
    
    func createRequest(withUrl url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!);
        request.setValue("localhost", forHTTPHeaderField: "Host");
        return request;
    }
}
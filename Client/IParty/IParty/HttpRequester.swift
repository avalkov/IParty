//
//  HttpRequester.swift
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

import Foundation

@objc class HttpRequester: NSObject {
    
    func test() {
//        httpGet(NSMutableURLRequest(URL: NSURL(string: "http://192.168.168.1:59651/")!))
    }
    
    func post(atUrl url: String, withFormDataData data: String, completion: (NSString) -> (), andExpectedStatusCodes validStatusCodes: [Int]) {
        
        let request = createRequest(withUrl: url);
        
        request.HTTPMethod = "POST";
        let postString = data;
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where !validStatusCodes.contains(httpStatus.statusCode) {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            completion(responseString!);
        }
        task.resume()
    }
    
    func createRequest(withUrl url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!);
        return request;
    }
}
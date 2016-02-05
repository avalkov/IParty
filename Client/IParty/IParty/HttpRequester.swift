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
    
    func uploadFile(atUrl url: String, withFileData data: NSData?, boundary: NSString?, mimetype: NSString?, andCustomHeaders customHeaders: [String: String]?, completion: (NSString?, NSNumber?) -> ()) {
    
        let request = createRequest(withUrl: url, andCustomHeaders: customHeaders);
        
        request.HTTPMethod = "POST";
        
        let filePathKey = "unknown";
        let filename = "unknown";
        
        let body = NSMutableData()
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(data!)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body;

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
    
    /*
    /// Create request
    ///
    /// - parameter userid:   The userid to be passed to web service
    /// - parameter password: The password to be passed to web service
    /// - parameter email:    The email address to be passed to web service
    ///
    /// - returns:            The NSURLRequest that was created
    
    func createRequest (userid userid: String, password: String, email: String) -> NSURLRequest {
        let param = [
            "user_id"  : userid,
            "email"    : email,
            "password" : password]  // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let url = NSURL(string: "https://example.com/imageupload.php")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let path1 = NSBundle.mainBundle().pathForResource("image1", ofType: "png") as String!
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", paths: [path1], boundary: boundary)
        
        return request
    }
    
    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, paths: [String]?, boundary: String) -> NSData {
        let body = NSMutableData()
        
        if paths != nil {
            for path in paths! {
                let url = NSURL(fileURLWithPath: path)
                let filename = url.lastPathComponent
                let data = NSData(contentsOfURL: url)!
                let mimetype = mimeTypeForPath(path)
                
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename!)\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.appendData(data)
                body.appendString("\r\n")
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }*/
}
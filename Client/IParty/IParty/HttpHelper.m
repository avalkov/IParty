//
//  HttpHelper.m
//  IParty
//
//  Created by Swifty on 2/5/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "HttpHelper.h"

@implementation HttpHelper

+(NSString *)getMimeTypeOfImage:(NSData *) imageData {
    
    uint8_t c;
    
    [imageData getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    
    return @"application/octet-stream";
}

+(NSString *)generateBoundary {
    return [[[NSUUID alloc] init] UUIDString];
}

@end

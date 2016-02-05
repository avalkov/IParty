//
//  HttpHelper.h
//  IParty
//
//  Created by Swifty on 2/5/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHelper : NSObject

+(NSString *)getMimeTypeOfImage:(NSData *) imageData;
+(NSString *)generateBoundary;

@end

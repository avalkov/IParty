//
//  AsyncTasksHelper.m
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "AsyncTasksHelper.h"

#import "IParty-Swift.h"

@implementation AsyncTasksHelper

+(void)loadImageAsyncAtTableCell:(NearbyPartyTableViewCell *) imageView fromUrl:(NSString *) url {
        
    id completion = ^(NSData *response, NSNumber *statusCode) {
        
        if ( response == nil ) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image.image = [UIImage imageWithData: response];
        });
    };
        
    HttpRequester *httpRequester = [[HttpRequester alloc] init];
    [httpRequester getDataAtUrl:url withCustomHeaders:nil completion:completion];
}


+(void)loadImageAsyncAtUIImageView:(UIImageView *) imageView fromUrl:(NSString *) url {
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        id completion = ^(NSData *response, NSNumber *statusCode) {
            
            if ( response == nil ) {
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData: response];
                [imageView setNeedsDisplay];
            });
        };
        
        HttpRequester *httpRequester = [[HttpRequester alloc] init];
        
        [httpRequester getDataAtUrl:url withCustomHeaders:nil completion:completion];
    });
}

@end

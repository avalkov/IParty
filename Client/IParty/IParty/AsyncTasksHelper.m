//
//  AsyncTasksHelper.m
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "AsyncTasksHelper.h"

@implementation AsyncTasksHelper

+(void)loadImageAsyncAtUIImageView:(UIImageView *) imageView fromUrl:(NSString *) url {
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = [UIImage imageWithData: data];
        });
    });
}

@end

//
//  AsyncTasksHelper.h
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AsyncTasksHelper : NSObject

+(void)loadImageAsyncAtUIImageView:(UIImageView *) imageView fromUrl:(NSString *) url;

@end

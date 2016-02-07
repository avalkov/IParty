//
//  AsyncTasksHelper.h
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "NearbyPartyTableViewCell.h"

@interface AsyncTasksHelper : NSObject

+(void)loadImageAsyncAtTableCell:(NearbyPartyTableViewCell *) imageView fromUrl:(NSString *) url;
+(void)loadImageAsyncAtUIImageView:(UIImageView *) imageView fromUrl:(NSString *) url;

@end

//
//  ReverseGeoLocation.h
//  IParty
//
//  Created by Swifty on 2/5/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ReverseGeoLocation: NSObject

-(NSString *)getGoogleAddressFromLatLong : (CGFloat)lat lon:(CGFloat)lon;

@end
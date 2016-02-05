//
//  ReverseGeoLocation.m
//  IParty
//
//  Created by Swifty on 2/5/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "ReverseGeoLocation.h"

@implementation ReverseGeoLocation

-(NSString *)getGoogleAddressFromLatLong : (CGFloat)lat lon:(CGFloat)lon {
    
    NSError *error = nil;
    
    NSString *lookUpString  = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false", lat,lon];
    lookUpString = [lookUpString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSData *jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:lookUpString]];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    
    NSArray *jsonResults = [jsonDict objectForKey:@"results"];
    NSString *address = [[jsonResults objectAtIndex:0] objectForKey:@"formatted_address"];
    
    return address;
}

@end
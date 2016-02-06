//
//  FindPartyRequestModel.m
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "FindPartyRequestModel.h"

@implementation FindPartyRequestModel

-(instancetype)initWithLongitude:(NSNumber *) longitude andWithLatitude:(NSNumber *) latitude {
    
    self = [super init];
    
    if(self) {
        
        self.Longitude = longitude;
        self.Latitude = latitude;
    }
    
    return self;
}

@end

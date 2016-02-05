//
//  CreatePartyRequestModel.m
//  IParty
//
//  Created by Swifty on 2/5/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "CreatePartyRequestModel.h"

@implementation CreatePartyRequestModel

-(instancetype)initWithTitle:(NSString *) title description:(NSString *)description locationAddress:(NSString *)locationAddress longitude:(NSNumber *) longitude latitude:(NSNumber *) latitude startTime:(NSString *) startTime {
    
    self = [super init];
    
    if(self) {
        self.title = title;
        self.pDescription = description;
        self.locationAddress = locationAddress;
        self.longitude = longitude;
        self.latitude = latitude;
        self.startTime = startTime;
    }
    
    return self;
}

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"pDescription"
                                                       }];
}

@end

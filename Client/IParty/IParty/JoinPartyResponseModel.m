//
//  JoinPartyResponseModel.m
//  IParty
//
//  Created by Swifty on 2/7/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "JoinPartyResponseModel.h"

@implementation JoinPartyResponseModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"MembersCount":@"membersCount"
                                                       }];
}

@end

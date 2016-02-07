//
//  PartyResponseModel.m
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "PartyResponseModel.h"

@implementation PartyResponseModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"Id":@"pId",
                                                       @"Title":@"title",
                                                       @"Description": @"pDescription",
                                                       @"Distance":@"distance",
                                                       @"ImagesUrls":@"imagesUrls"
                                                       }];
}

@end

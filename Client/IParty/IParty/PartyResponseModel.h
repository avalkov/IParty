//
//  PartyResponseModel.h
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel/JSONModel.h"

@interface PartyResponseModel : JSONModel

@property (nonatomic, strong) NSNumber *pId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *pDescription;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSMutableArray *imagesUrls;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSNumber *membersCount;
@property (nonatomic, strong) NSString *locationAddress;

@end

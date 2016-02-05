//
//  CreatePartyRequestModel.h
//  IParty
//
//  Created by Swifty on 2/5/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel/JSONModel.h"

@interface CreatePartyRequestModel : JSONModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *pDescription;
@property (nonatomic, strong) NSString *locationAddress;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSString *startTime;

-(instancetype)initWithTitle:(NSString *) title description:(NSString *)description locationAddress:(NSString *)locationAddress longitude:(NSNumber *) longitude latitude:(NSNumber *) latitude startTime:(NSString *) startTime;

@end

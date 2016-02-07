//
//  JoinPartyResponseModel.h
//  IParty
//
//  Created by Swifty on 2/7/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JoinPartyResponseModel : JSONModel

@property (nonatomic, strong) NSNumber *membersCount;

@end

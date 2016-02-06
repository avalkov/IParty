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

@end

//
//  FindPartyRequestModel.h
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FindPartyRequestModel : JSONModel

@property (nonatomic, strong) NSNumber *Latitude;
@property (nonatomic, strong) NSNumber *Longitude;

-(instancetype)initWithLongitude:(NSNumber *) longitude andWithLatitude:(NSNumber *) latitude;

@end

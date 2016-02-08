//
//  ActionModel.h
//  IParty
//
//  Created by Swifty on 2/7/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionModel : NSObject

@property (nonatomic, strong) NSString *pDescription;
@property (nonatomic, strong) NSString *pTitle;

-(instancetype)initWithTitle:(NSString *)title andWithDescription:(NSString *)description;

@end

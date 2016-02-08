//
//  ActionModel.m
//  IParty
//
//  Created by Swifty on 2/7/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "ActionModel.h"

@implementation ActionModel

-(instancetype)initWithTitle:(NSString *)title andWithDescription:(NSString *)description {
    
    self = [super init];
    
    if(self) {
        self.pTitle = title;
        self.pDescription = description;
    }
    
    return self;
}

@end

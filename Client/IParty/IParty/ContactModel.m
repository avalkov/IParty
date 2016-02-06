//
//  ContactModel.m
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

-(instancetype)initWithName:(NSString *)name {
    
    self = [super init];
    
    if(self) {
        self.name = name;
    }
    
    return self;
}

-(NSMutableArray *)mobilePhoneNumbers {
    
    if(_mobilePhoneNumbers == nil) {
        _mobilePhoneNumbers = [[NSMutableArray alloc] init];
    }
    
    return _mobilePhoneNumbers;
}

@end

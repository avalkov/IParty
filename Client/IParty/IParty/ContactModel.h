//
//  ContactModel.h
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *mobilePhoneNumbers;

-(instancetype)initWithName:(NSString *)name;

@end

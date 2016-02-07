//
//  PartyDetailsViewController.h
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PartyResponseModel.h"

@interface PartyDetailsViewController : UIViewController

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) PartyResponseModel *party;

@end

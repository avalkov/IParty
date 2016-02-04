//
//  AppDelegate.h
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DBManager *globalDBManager;

@end


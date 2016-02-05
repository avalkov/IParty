//
//  MessageBox.h
//  IParty
//
//  Created by Swifty on 2/3/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MessageBox : NSObject

+ (void)showAlertWithTitle:(NSString *)title viewController:(UIViewController*) viewController andMessage:(NSString *) message;
+ (void)showConfirmationBoxWithTitle:(NSString *)title viewController:(UIViewController*) viewController completion: (void(^)(UIAlertAction *)) completion andMessage:(NSString *) message;

@end

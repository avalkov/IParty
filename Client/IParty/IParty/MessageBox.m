//
//  MessageBox.m
//  IParty
//
//  Created by Swifty on 2/3/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "MessageBox.h"

@implementation MessageBox

- (void)showAlertWithTitle:(NSString *)title viewController:(UIViewController*) viewController andMessage:(NSString *) message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end

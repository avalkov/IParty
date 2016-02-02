//
//  LoginViewController.m
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController()

@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)registerAction:(id)sender {
    [self performSegueWithIdentifier:@"registerIdentifer" sender:self];
}

@end

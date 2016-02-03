//
//  RegisterViewController.m
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "RegisterViewController.h"
#import "MessageBox.h"

#import "IParty-Swift.h"

@interface RegisterViewController()
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordInput;

@end

@implementation RegisterViewController

-(void)viewDidLoad {

    [super viewDidLoad];
}

- (IBAction)registerAction:(id)sender {
    
    if([self validateInputFields] == NO) {
        return;
    }
    
    NSString *username = self.usernameInput.text;
    NSString *password = self.passwordInput.text;
    NSString *repeatPassword = self.repeatPasswordInput.text;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL)validateInputFields {
    
    if(self.usernameInput.text.length == 0) {
        [[MessageBox alloc] showAlertWithTitle:@"Empty username" viewController:self andMessage:@"Please fill username"];
        return NO;
    }
    
    if(self.passwordInput.text.length == 0) {
        [[MessageBox alloc] showAlertWithTitle:@"Empty password" viewController:self andMessage:@"Please fill password"];
        return NO;
    }
    
    if(self.repeatPasswordInput.text.length == 0) {
        [[MessageBox alloc] showAlertWithTitle:@"Empty repeat password" viewController:self andMessage:@"Please fill repeat password"];
        return NO;
    }
    
    return YES;
}

@end

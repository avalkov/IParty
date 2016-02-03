//
//  RegisterViewController.m
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "AppConstants.h"
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
    
    NSString *data = [NSString stringWithFormat:@"Email=%@&Password=%@&ConfirmPassword=%@", username, password, repeatPassword];
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REGISTRATION_URI];
    
    id registrationCompleteionBlock = ^(NSString *response, NSNumber *statusCode) {
        
        if(response == nil && statusCode == nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[MessageBox alloc] showAlertWithTitle:@"No Internet" viewController:self andMessage:@"Please check your internet connection and try again"];
            });
            
        } if([statusCode intValue] == HTTP_STATUS_OK) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[MessageBox alloc] showAlertWithTitle:@"Success" viewController:self andMessage:@"Successfully registered"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[MessageBox alloc] showAlertWithTitle:@"Error" viewController:self andMessage:@"Username already taken"];
            });
        }
    };
    
    HttpRequester *httpRequester = [[HttpRequester alloc] init];
    [httpRequester postAtUrl:url withFormDataData:data completion:registrationCompleteionBlock];
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
    
    if([self.passwordInput.text isEqualToString:self.repeatPasswordInput.text] == NO) {
        [[MessageBox alloc] showAlertWithTitle:@"Error" viewController:self andMessage:@"Passwords doesnt match"];
        return NO;
    }
    
    return YES;
}

@end

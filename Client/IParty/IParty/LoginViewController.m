//
//  LoginViewController.m
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConstants.h"
#import "LoginViewController.h"
#import "MessageBox.h"

#import "IParty-Swift.h"

@interface LoginViewController()
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)loginAction:(id)sender {
    
    if([self validateFields] == YES) {
        
        NSString *username = self.usernameInput.text;
        NSString *password = self.passwordInput.text;
        
        HttpRequester *httpRequester = [[HttpRequester alloc] init];
        
        NSString *data = [NSString stringWithFormat:@"Username=%@&Password=%@&grant_type=password", username, password];
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, LOGIN_URI];
        
        id loginCompletionBlock = ^(NSString *response, NSNumber *statusCode) {
            
            if(response == nil && statusCode == nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[MessageBox alloc] showAlertWithTitle:@"No Internet" viewController:self andMessage:@"Please check your internet connection and try again"];
                });
                
            } if([statusCode intValue] == HTTP_STATUS_OK) {
                
                NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@", json[@"access_token"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{

                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[MessageBox alloc] showAlertWithTitle:@"Error" viewController:self andMessage:@"Wrong username or password"];
                });
            }
        };
        
        [httpRequester postAtUrl:url withFormDataData:data completion:loginCompletionBlock];
    }
}

- (IBAction)registerAction:(id)sender {
    [self performSegueWithIdentifier:@"registerIdentifer" sender:self];
}

-(BOOL)validateFields {
    
    if(self.usernameInput.text.length == 0) {
        [[MessageBox alloc] showAlertWithTitle:@"Empty username" viewController:self andMessage:@"Please fill username"];
        return NO;
    }
    
    if(self.passwordInput.text.length == 0) {
        [[MessageBox alloc] showAlertWithTitle:@"Empty password" viewController:self andMessage:@"Please fill password"];
        return NO;
    }
    
    return YES;
}

@end

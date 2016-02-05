//
//  LoginViewController.m
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MainMenuViewController.h"

#import "AppDelegate.h"
#import "AppConstants.h"
#import "DBManager.h"
#import "LoginViewController.h"
#import "MessageBox.h"

#import "IParty-Swift.h"

@interface LoginViewController() <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@property (weak, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSString *token;

@end

@implementation LoginViewController


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.dbManager = delegate.globalDBManager;
    
    self.logoImage.hidden = YES;
    self.usernameInput.hidden = YES;
    self.passwordInput.hidden = YES;
    self.loginButton.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    self.token = [self loadTokenFromDb];
    
    if(self.token != nil) {
        
        [self performSegueWithIdentifier:@"mainIdentifer" sender:self];
        
    } else {
        
        self.logoImage.hidden = NO;
        self.usernameInput.hidden = NO;
        self.passwordInput.hidden = NO;
        self.loginButton.hidden = NO;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"mainIdentifer"] && [segue.destinationViewController isKindOfClass:[MainMenuViewController class]]) {
        
        MainMenuViewController *mmvc = (MainMenuViewController *)segue.destinationViewController;
        mmvc.token = self.token;
    }
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
                    __weak typeof(self) weakSelf = self;
                    [[MessageBox alloc] showAlertWithTitle:@"No Internet" viewController:weakSelf andMessage:@"Please check your internet connection and try again"];
                });
                
            } if([statusCode intValue] == HTTP_STATUS_OK) {
                
                NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    __weak typeof(self) weakSelf = self;
                    
                    id completion = ^(UIAlertAction *action) {
                        
                        if([[action title] isEqualToString:@"YES"] == YES) {
                            
                            [self saveTokenToDb:json[@"access_token"] andUsername: username];
                        }
                        
                        self.token = json[@"access_token"];
                        
                        [self performSegueWithIdentifier:@"mainIdentifer" sender:self];
                    };
                    
                    [[MessageBox alloc] showConfirmationBoxWithTitle:@"Stay signed" viewController:weakSelf completion:completion andMessage:@"Would you like to stay signed in ?"];
                });
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    __weak typeof(self) weakSelf = self;
                    [[MessageBox alloc] showAlertWithTitle:@"Error" viewController:weakSelf andMessage:@"Wrong username or password"];
                });
            }
        };
        
        [httpRequester postAtUrl:url withFormDataData:data andCustomHeaders:nil completion:loginCompletionBlock];
    }
}

- (IBAction)registerAction:(id)sender {
    [self performSegueWithIdentifier:@"registerIdentifer" sender:self];
}

- (BOOL)validateFields {
    
    if(self.usernameInput.text.length == 0) {
        __weak typeof(self) weakSelf = self;
        [[MessageBox alloc] showAlertWithTitle:@"Empty username" viewController:weakSelf andMessage:@"Please fill username"];
        return NO;
    }
    
    if(self.passwordInput.text.length == 0) {
        __weak typeof(self) weakSelf = self;
        [[MessageBox alloc] showAlertWithTitle:@"Empty password" viewController:weakSelf andMessage:@"Please fill password"];
        return NO;
    }
    
    return YES;
}

- (void)saveTokenToDb:(NSString *) token andUsername:(NSString *) username {
    
    NSString *deleteOldTokens = [NSString stringWithFormat:@"delete from tokens"];
    [self.dbManager executeQuery:deleteOldTokens];
    
    NSString *query = [NSString stringWithFormat:@"insert into tokens values(null, '%@', '%@')", username, token];
    [self.dbManager executeQuery:query];
}

- (NSString *)loadTokenFromDb {
    
    NSString *query = [NSString stringWithFormat:@"select token from tokens"];
    NSArray *tokensResult = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if([tokensResult count] > 0) {
        return [[tokensResult objectAtIndex:0] objectAtIndex:0];
    }
    
    return nil;
}

@end

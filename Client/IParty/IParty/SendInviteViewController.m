//
//  SendInviteViewController.m
//  IParty
//
//  Created by Swifty on 2/4/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

@import Contacts;
@import ContactsUI;

#import "SendInviteViewController.h"

@interface SendInviteViewController() <CNContactPickerDelegate>

@end

@implementation SendInviteViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)browseContactsAction:(id)sender {
    
    CNContactPickerViewController *peoplePicker = [[CNContactPickerViewController alloc] init];
    
    peoplePicker.delegate = self;
    
    [self presentViewController:peoplePicker animated:true completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    
    for(int i = 0; i < [contact.phoneNumbers count]; i++) {
        
        CNLabeledValue<CNPhoneNumber *> * phoneNumberEntry = contact.phoneNumbers[i];
        
        if([phoneNumberEntry.label isEqualToString:@"_$!<Mobile>!$_"]) {
            NSLog(@"%@ %@", contact.givenName, contact.familyName);
            NSLog(@"%@", phoneNumberEntry.value.stringValue);
        }
    }
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

@end

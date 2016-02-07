//
//  SendInviteViewController.m
//  IParty
//
//  Created by Swifty on 2/4/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

@import Contacts;
@import ContactsUI;

#import <MessageUI/MFMessageComposeViewController.h>

#import "AppConstants.h"
#import "SendInviteViewController.h"
#import "ContactModel.h"
#import "PartyResponseModel.h"
#import "MessageBox.h"

#import "JSONModel.h"

#import "IParty-Swift.h"

@interface SendInviteViewController() <CNContactPickerDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *partyPicker;

@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSMutableArray *parties;
@property (nonatomic, strong) PartyResponseModel *selectedParty;

@end

@implementation SendInviteViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
 
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.partyPicker.delegate = self;
    self.partyPicker.dataSource = self;
    
    [self loadUserParties];
}

-(NSMutableArray *)contacts {
    
    if(_contacts == nil) {
        _contacts = [[NSMutableArray alloc] init];
    }
    
    return _contacts;
}

-(NSMutableArray *)parties {

    if(_parties == nil) {
        _parties = [[NSMutableArray alloc] init];
    }
    
    return _parties;
}

-(void)loadUserParties {
    
    id completion = ^(NSString *response, NSNumber *statusCode) {
        
        if(response == nil && statusCode == nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                [MessageBox showAlertWithTitle:@"No Internet" viewController:weakSelf andMessage:@"Please check your internet connection and try again"];
            });
            
            return;
        }
        
        NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *jsonArr = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        self.parties = [PartyResponseModel arrayOfModelsFromDictionaries:jsonArr error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([self.parties count] == 0) {
                [MessageBox showAlertWithTitle:@"Error" viewController:self andMessage:@"You are not member of any parties"];
            } else {
                self.selectedParty = [self.parties objectAtIndex:0];
                [self.partyPicker reloadAllComponents];
            }
        });
    };
    
    HttpRequester *httpRequester = [[HttpRequester alloc] init];
    
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, GET_USER_PARTIES_URI];
    NSDictionary *customHeaders = @{
                                    @"Authorization": [NSString stringWithFormat:@"%@%@", @"Bearer ", self.token]
                                    };
    
    [httpRequester getAtUrl:serverUrl withCustomHeaders:customHeaders completion:completion];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedParty = self.parties[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.parties count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PartyResponseModel *partyResponseModel = self.parties[row];
    
    return partyResponseModel.title;
}

- (IBAction)browseContactsAction:(id)sender {
    
    CNContactPickerViewController *peoplePicker = [[CNContactPickerViewController alloc] init];
    
    peoplePicker.delegate = self;
    
    [self presentViewController:peoplePicker animated:true completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    
    NSString *contactName = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    ContactModel *contactModel = [[ContactModel alloc] initWithName:contactName];
    
    for(int i = 0; i < [contact.phoneNumbers count]; i++) {
        
        CNLabeledValue<CNPhoneNumber *> * phoneNumberEntry = contact.phoneNumbers[i];
        
        if([phoneNumberEntry.label isEqualToString:@"_$!<Mobile>!$_"]) {
            
            [contactModel.mobilePhoneNumbers addObject:phoneNumberEntry.value.stringValue];
        }
    }
    
    [self.contacts addObject:contactModel];
    
    [self.tableView reloadData];
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contacts count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    
    ContactModel *contact = self.contacts[indexPath.row];
    cell.textLabel.text = contact.name;
    
    return cell;
}

- (IBAction)sendInvitesAction:(id)sender {
    
    if(self.selectedParty == nil) {
        __weak typeof(self) weakSelf = self;
        [MessageBox showAlertWithTitle:@"Error" viewController:weakSelf andMessage:@"Please select party to which to invite some of your contacts"];
        return;
    }
    
    if([self.contacts count] == 0) {
        __weak typeof(self) weakSelf = self;
        [MessageBox showAlertWithTitle:@"Error" viewController:weakSelf andMessage:@"Please select contacts which to send invites to"];
        return;
    }
    
    NSMutableArray *recipients = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [self.contacts count]; i++) {
        ContactModel *contact = self.contacts[i];
        for(int j = 0; j < [contact.mobilePhoneNumbers count]; j++) {
            [recipients addObject:contact.mobilePhoneNumbers[j]];
        }
    }
    
    MFMessageComposeViewController *sendSMSController = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        sendSMSController.body = self.selectedParty.pDescription;
        sendSMSController.recipients = recipients;
        sendSMSController.messageComposeDelegate = self;
        [self presentViewController:sendSMSController animated:YES completion:nil];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
     if (result == MessageComposeResultCancelled)
         NSLog(@"Message cancelled");
     else if (result == MessageComposeResultSent)
         NSLog(@"Message sent");
     else
         NSLog(@"Message failed");
}

@end

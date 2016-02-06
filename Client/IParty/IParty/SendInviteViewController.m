//
//  SendInviteViewController.m
//  IParty
//
//  Created by Swifty on 2/4/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

@import Contacts;
@import ContactsUI;

#import "AppConstants.h"
#import "SendInviteViewController.h"
#import "ContactModel.h"
#import "PartyResponseModel.h"

#import "JSONModel.h"

#import "IParty-Swift.h"

@interface SendInviteViewController() <CNContactPickerDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *partyPicker;

@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSMutableArray *parties;

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
        
        NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *jsonArr = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        self.parties = [PartyResponseModel arrayOfModelsFromDictionaries:jsonArr error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.partyPicker reloadAllComponents];
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
    NSLog(@"%@", self.parties[row]);
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
            // NSLog(@"%@ %@", contact.givenName, contact.familyName);
            // NSLog(@"%@", phoneNumberEntry.value.stringValue);
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


@end

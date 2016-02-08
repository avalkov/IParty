//
//  PartyDetailsViewController.m
//  IParty
//
//  Created by Swifty on 2/6/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "AppDelegate.h"
#import "PartyDetailsViewController.h"
#import "AppConstants.h"
#import "AsyncTasksHelper.h"
#import "JoinPartyResponseModel.h"
#import "MessageBox.h"
#import "HistoryLogger.h"

#import "UIView+Toast.h"

#import "IParty-Swift.h"

@interface PartyDetailsViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;
@property (weak, nonatomic) IBOutlet UILabel *partyTitle;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *partyDescription;
@property (weak, nonatomic) IBOutlet UILabel *partyAddress;

@property (weak, nonatomic) DBManager *dbManager;

@end

@implementation PartyDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.dbManager = delegate.globalDBManager;
    
    self.partyDescription.text = self.party.pDescription;
    self.partyAddress.text = self.party.locationAddress;
    [self setPartyTitleWithPeopleJoinedCount: [self.party.membersCount intValue]];
    
    [self.image setUserInteractionEnabled:YES];
    
    if(self.party.imagesUrls != nil && [self.party.imagesUrls count] > 0) {

        [self loadPartyImageFromIndex:0];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.image addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(swipeAction:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.image addGestureRecognizer:swipeRight];
    }
}

- (void)setPartyTitleWithPeopleJoinedCount:(int) count {
    self.partyTitle.text = [NSString stringWithFormat:@"%d people joined", count];
}

int currentImageIndex = 0;

- (void)swipeAction:(UISwipeGestureRecognizer*)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        currentImageIndex++;
        if(currentImageIndex >= [self.party.imagesUrls count]) {
            currentImageIndex = 0;
        }

        [self loadPartyImageFromIndex:currentImageIndex];
        
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        
        currentImageIndex--;
        if(currentImageIndex < 0) {
            currentImageIndex = (int) [self.party.imagesUrls count] - 1;
        }
        
        [self loadPartyImageFromIndex:currentImageIndex];
    }
}

- (void)loadPartyImageFromIndex:(int)index {
    
    NSString *url = [[self.party.imagesUrls[currentImageIndex] objectForKey:@"Url"] stringByReplacingOccurrencesOfString:@"http://localhost/" withString:SERVER_URL];
    [AsyncTasksHelper loadImageAsyncAtUIImageView:self.image fromUrl:url];
}

- (IBAction)joinPartyAction:(id)sender {
    
    id completion = ^(NSString *response, NSNumber *statusCode) {
        
        if(response == nil && statusCode == nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                [MessageBox showAlertWithTitle:@"No Internet" viewController:weakSelf andMessage:@"Please check your internet connection and try again"];
            });
            
            return;
            
        } else if([response length] > 0) {
            
            JoinPartyResponseModel *joinPartyResponseModel = [[JoinPartyResponseModel alloc] initWithString:response error:nil];
            
            if(joinPartyResponseModel != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setPartyTitleWithPeopleJoinedCount: [joinPartyResponseModel.membersCount intValue]];
                    });

                self.party.membersCount = [NSNumber numberWithInt:[joinPartyResponseModel.membersCount intValue]];
                
                [HistoryLogger logActionToHistoryAtDbManager:self.dbManager title:@"Joined party" andDescription:[NSString stringWithFormat:@"%@\r\n%@", self.partyTitle.text, self.partyDescription]];
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"You have already joined that party... go check your history"];
            });
        }
    };
    
    HttpRequester *httpRequester = [[HttpRequester alloc] init];
    
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@/%@", SERVER_URL, JOIN_PARTY_URI, self.party.pId];
    NSDictionary *customHeaders = @{
                                    @"Content-Type": @"application/json",
                                    @"Authorization": [NSString stringWithFormat:@"%@%@", @"Bearer ", self.token]
                                    };
    
    [httpRequester getAtUrl:serverUrl withCustomHeaders:customHeaders completion:completion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

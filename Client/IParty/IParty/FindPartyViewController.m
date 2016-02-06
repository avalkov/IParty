//
//  FindPartyViewController.m
//  IParty
//
//  Created by Swifty on 2/4/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "AppConstants.h"
#import "FindPartyViewController.h"
#import "NearbyPartyTableViewCell.h"
#import "MessageBox.h"
#import "FindPartyRequestModel.h"
#import "PartyResponseModel.h"
#import "NearbyPartyTableViewCell.h"
#import "AsyncTasksHelper.h"

#import "IParty-Swift.h"

@interface FindPartyViewController() <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSMutableArray *parties;

@end

@implementation FindPartyViewController

CLLocationManager *locationManager;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NearbyPartyTableViewCell" bundle:nil] forCellReuseIdentifier:@"TableCellIdentifer"];
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self tryDetectLocation] == NO) {
        __weak typeof(self) weakSelf = self;
        [MessageBox showAlertWithTitle:@"Error" viewController:weakSelf andMessage:@"Please enable location service for this app"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (CLLocationManager *)locationManager {
    
    if(_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    return _locationManager;
}

- (NSMutableArray *)parties {
    
    if(_parties == nil) {
        _parties = [[NSMutableArray alloc] init];
    }
    
    return _parties;
}

-(void)findNearbyParties {
    
    id completion = ^(NSString *response, NSNumber *statusCode) {
        
        NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *jsonArr = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        self.parties = [PartyResponseModel arrayOfModelsFromDictionaries:jsonArr error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([self.parties count] == 0) {
                [MessageBox showAlertWithTitle:@"Too bad" viewController:self andMessage:@"No parties around you :("];
            } else {
                [self.tableView reloadData];
            }
        });
    };
    
    HttpRequester *httpRequester = [[HttpRequester alloc] init];
    
    FindPartyRequestModel *findPartyRequestModel = [[FindPartyRequestModel alloc] initWithLongitude:self.longitude andWithLatitude:self.latitude];
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, FIND_NEARBY_PARTIES_URI];
    NSDictionary *customHeaders = @{
                                    @"Content-Type": @"application/json",
                                    @"Authorization": [NSString stringWithFormat:@"%@%@", @"Bearer ", self.token]
                                    };
    
    [httpRequester postAtUrl:serverUrl withFormDataData:[findPartyRequestModel toJSONString] andCustomHeaders:customHeaders completion:completion];
}

- (BOOL)tryDetectLocation {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
        if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            return NO;
        }
    }
    
    [self.locationManager startUpdatingLocation];

    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.locationManager stopUpdatingLocation];
    
    CLLocation * location = [locations lastObject];
    
    self.latitude = [NSNumber numberWithFloat:location.coordinate.latitude];
    self.longitude = [NSNumber numberWithFloat:location.coordinate.longitude];
    
    [self findNearbyParties];
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.parties count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *originalCell = [tableView dequeueReusableCellWithIdentifier:@"TableCellIdentifer"];
    
    if(![originalCell isKindOfClass: [NearbyPartyTableViewCell class]] || originalCell == nil) {
        originalCell = [[[NSBundle mainBundle] loadNibNamed:@"NearbyPartyTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    NearbyPartyTableViewCell *cell = (NearbyPartyTableViewCell *) originalCell;
    
    PartyResponseModel *party = self.parties[indexPath.row];
    
    cell.title.text = party.title;
    cell.underTitle.text = [NSString stringWithFormat:@"%@ km away", party.distance];
    
    if(party.frontImageUrl != nil && [party.frontImageUrl length] > 0) {
        [AsyncTasksHelper loadImageAsyncAtUIImageView:cell.image fromUrl:party.frontImageUrl];
    }
    
    return cell;
}


@end

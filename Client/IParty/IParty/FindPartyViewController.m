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
#import "Radar.h"
#import "RadarArcs.h"
#import "PartyDetailsViewController.h"

#import "IParty-Swift.h"

@interface FindPartyViewController() <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSMutableArray *parties;

@end

@implementation FindPartyViewController

RadarArcs *arcsView;
Radar *radarView;
NSIndexPath *lastIndexPath;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NearbyPartyTableViewCell" bundle:nil] forCellReuseIdentifier:@"TableCellIdentifer"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapAction:)];
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.tableView.alpha = 0;
    
    arcsView = [[RadarArcs alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 140, self.view.frame.size.height / 2 - 140, 280, 280)];
    arcsView.layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view addSubview:arcsView];
    radarView = [[Radar alloc] initWithFrame:CGRectMake(3, 3, self.view.frame.size.width-6, self.view.frame.size.height-6)];
    radarView.layer.contentsScale = [UIScreen mainScreen].scale;
    radarView.alpha = 0.68;
    [self.view addSubview:radarView];
    [self spinRadar];
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

-(void) cellTapAction:(UIGestureRecognizer *) recognizer {
    CGPoint point = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath != nil) {
        lastIndexPath = indexPath;
        [self performSegueWithIdentifier:@"partyDetails" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"partyDetails"] && [segue.destinationViewController isKindOfClass:[PartyDetailsViewController class]]) {
        
        PartyDetailsViewController *pdvc = (PartyDetailsViewController *)segue.destinationViewController;
        pdvc.token = self.token;
        pdvc.party = self.parties[lastIndexPath.row];
        NSLog(@"%ld", (long)lastIndexPath.row);
    }
}

-(void)spinRadar {

    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin.duration = 1;
    spin.toValue = [NSNumber numberWithFloat:-M_PI];
    spin.cumulative = YES;
    spin.removedOnCompletion = NO;
    spin.repeatCount = MAXFLOAT;
    [radarView.layer addAnimation:spin forKey:@"spinRadarView"];
}

-(void)findNearbyParties {
    
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
                
                [MessageBox showAlertWithTitle:@"Too bad" viewController:self andMessage:@"No parties around you :("];
                
            } else {
            
                [self.tableView reloadData];
                
                [UIView animateWithDuration:1 animations:^{
                    radarView.alpha = 0;
                } completion:^(BOOL finished) {
                    if(finished == YES) {
                        [radarView removeFromSuperview];
                    }
                }];
                
                [UIView animateWithDuration:1 animations:^{
                    arcsView.alpha = 0;
                } completion:^(BOOL finished) {
                    if(finished == YES) {
                        [arcsView removeFromSuperview];
                    }
                }];
                
                [UIView animateWithDuration:1 animations:^{
                                     self.tableView.alpha = 1;
                                 }];
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
    
    if([self.parties count] == 0) {
        return originalCell;
    }
    
    NearbyPartyTableViewCell *cell = (NearbyPartyTableViewCell *) originalCell;
    
    PartyResponseModel *party = self.parties[indexPath.row];
    
    cell.title.text = party.title;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@ km away", party.distance];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:party.startTime];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-EE HH:mm"];
    
    cell.startTimeLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    
    if(party.imagesUrls != nil && [party.imagesUrls count] > 0) {
        NSString *url = [[party.imagesUrls[0] objectForKey:@"Url"] stringByReplacingOccurrencesOfString:@"http://localhost/" withString:SERVER_URL];
        
        id completion = ^(NSData *response, NSNumber *statusCode) {
            
            if ( response == nil ) {
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                    cell.image.image = [UIImage imageWithData: response];
                    [cell setNeedsLayout];
            });
        };
        
        HttpRequester *httpRequester = [[HttpRequester alloc] init];
        
        [httpRequester getDataAtUrl:url withCustomHeaders:nil completion:completion];
    }
    
    
    return cell;
}

@end

//
//  SetupPartyViewController.m
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "AppDelegate.h"
#import "AppConstants.h"
#import "SetupPartyViewController.h"
#import "UploadImageCollectionViewCell.h"
#import "MessageBox.h"
#import "CreatePartyRequestModel.h"
#import "ReverseGeoLocation.h"
#import "HttpHelper.h"
#import "PartyResponseModel.h"
#import "HistoryLogger.h"

#import "UIView+Toast.h"
#import "JSONModel.h"

#import "IParty-Swift.h"

@interface SetupPartyViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextView *descriptionInput;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateInput;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesForUploadCollectionView;

@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *locationAddress;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *latitude;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) DBManager *dbManager;

@property (nonatomic) int imagesForUploadCount;
@property (atomic) int imagesUploadedCount;

@end

@implementation SetupPartyViewController

NSMutableArray *imagesForUploadData;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.dbManager = delegate.globalDBManager;
    
    self.imagesForUploadCollectionView.delegate = self;
    self.imagesForUploadCollectionView.dataSource = self;
    
    imagesForUploadData = [[NSMutableArray alloc] init];
    
    CGRect rect = self.imagesForUploadCollectionView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = [[UIScreen mainScreen] bounds].size.width;
    rect.size.height = [[UIScreen mainScreen] bounds].size.height;
    
    self.imagesForUploadCollectionView.frame = rect;
    self.imagesForUploadCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.imagesForUploadCollectionView registerNib:[UINib nibWithNibName:@"UploadImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCellIdentifer"];
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectLocation)];
    doubleTap.numberOfTapsRequired = 2;
    [self.locationInput addGestureRecognizer:doubleTap];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = NO;
}

- (CLLocationManager *)locationManager {
    
    if(_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    return _locationManager;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [imagesForUploadData count] + 1;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CollectionCellIdentifer";
    
    UICollectionViewCell *originalCell = [cv dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    if(![originalCell isKindOfClass: [UploadImageCollectionViewCell class]] ||originalCell == nil) {
        originalCell = [[[NSBundle mainBundle] loadNibNamed:@"UploadImageCollectionViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    UploadImageCollectionViewCell *cell = (UploadImageCollectionViewCell*) originalCell;
    
    if(indexPath.row == 0 && indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"uploadImage"];
    } else {
        cell.imageView.image = imagesForUploadData[indexPath.row - 1];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && indexPath.section == 0) {
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:pickerView animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:true completion:nil];

    [imagesForUploadData addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [self.imagesForUploadCollectionView reloadData];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.descriptionInput scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO]; // Fixes problem: I can't type description after rotation
}
- (IBAction)datePickerAction:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    self.startTime = [dateFormatter stringFromDate:self.dateInput.date];
}

- (void)detectLocation {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [manager stopUpdatingLocation];
    
    CLLocation * location = [locations lastObject];
    
    self.latitude = [NSNumber numberWithFloat:location.coordinate.latitude];
    self.longitude = [NSNumber numberWithFloat:location.coordinate.longitude];
    self.locationAddress = [ReverseGeoLocation getGoogleAddressFromLatLong:self.latitude.floatValue lon:self.longitude.floatValue];
    
    self.locationInput.text = self.locationAddress;
}

- (BOOL)validateFields {
    
    if(self.titleInput.text.length == 0) {
        __weak typeof(self) weakSelf = self;
        [MessageBox showAlertWithTitle:@"Empty title" viewController:weakSelf andMessage:@"Please enter title"];
        return NO;
    }
    
    if(self.descriptionInput.text.length == 0) {
        __weak typeof(self) weakSelf = self;
        [MessageBox showAlertWithTitle:@"Empty description" viewController:weakSelf andMessage:@"Please enter description"];
        return NO;
    }
    
    if(self.locationInput.text.length == 0) {
        __weak typeof(self) weakSelf = self;
        [MessageBox showAlertWithTitle:@"Empty location" viewController:weakSelf andMessage:@"Please enter location"];
        return NO;
    }
    
    if(self.startTime.length == 0) {
        __weak typeof(self) weakSelf = self;
        [MessageBox showAlertWithTitle:@"Unknown start time" viewController:weakSelf andMessage:@"Please select start time"];
        return NO;
    }
    
    return YES;
}

- (IBAction)submitAction:(id)sender {
    
    if([self validateFields] == NO) {
        return;
    }
    
    [self.view makeToast:@"Please hold while processing your party..."];
    [self.view makeToastActivity:CSToastPositionCenter];
    
    id completion = ^(NSString *response, NSNumber *statusCode) {

        if(response == nil && statusCode == nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                [MessageBox showAlertWithTitle:@"No Internet" viewController:weakSelf andMessage:@"Please check your internet connection and try again"];
            });
            
            return;
            
        } else if([statusCode intValue] == HTTP_STATUS_CREATED) {
            
            [HistoryLogger logActionToHistoryAtDbManager:self.dbManager title:@"Created party" andDescription:[NSString stringWithFormat:@"%@ %@", self.titleInput.text, self.descriptionInput.text]];
            
            if([imagesForUploadData count] > 0) {
                
                PartyResponseModel *partyResponseModel = [[PartyResponseModel alloc] initWithString:response error:nil];
                [self uploadImages: partyResponseModel];
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                [MessageBox showAlertWithTitle:@"Error" viewController:weakSelf andMessage:@"You tried to setup party with invalid data"];
            });
        }
    };
    
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, CREATE_PARTY_URI];
    
    CreatePartyRequestModel *createPartyRequestModel = [[CreatePartyRequestModel alloc] initWithTitle:self.titleInput.text description:self.descriptionInput.text locationAddress:self.locationAddress longitude:self.longitude latitude:self.latitude startTime:self.startTime];
    
    NSDictionary *customHeaders = @{
                                    @"Content-Type": @"application/json",
                                    @"Authorization": [NSString stringWithFormat:@"%@%@", @"Bearer ", self.token]
                                    };
    
    HttpRequester *httpRequester = [[HttpRequester alloc] init];
    [httpRequester postAtUrl:serverUrl withFormDataData:[createPartyRequestModel toJSONString] andCustomHeaders:customHeaders completion:completion];
}

- (void)uploadImages: (PartyResponseModel *)partyResponseModel  {
    
    id completion = ^(NSString *response, NSNumber *statusCode) {
        
        self.imagesUploadedCount += 1;
        
        if(self.imagesUploadedCount == self.imagesForUploadCount) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    };

    
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@/%@", SERVER_URL, UPLOAD_IMAGE_URI, partyResponseModel.pId];
    
    NSDictionary *customHeaders = @{
                                    @"Authorization": [NSString stringWithFormat:@"%@%@", @"Bearer ", self.token],
                                    @"Content-Type": [NSString stringWithFormat:@"%@%@", @"multipart/form-data; boundary=", MIME_TYPE_BOUNDARY]
                                    };
    
    self.imagesForUploadCount = (int) [imagesForUploadData count];
    self.imagesUploadedCount = 0;
    
    for(int i = 0; i < self.imagesForUploadCount; i++) {

        HttpRequester *httpRequester = [[HttpRequester alloc] init];
        
        NSData *data = UIImageJPEGRepresentation([imagesForUploadData objectAtIndex:i], 0.1f);
    
        [httpRequester uploadFileAtUrl:serverUrl withFileData:data boundary:MIME_TYPE_BOUNDARY mimetype:[HttpHelper getMimeTypeOfImage:data] andCustomHeaders:customHeaders completion:completion];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

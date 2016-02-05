//
//  SetupPartyViewController.m
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "AppConstants.h"
#import "SetupPartyViewController.h"
#import "UploadImageCollectionViewCell.h"

#import "IParty-Swift.h"

@interface SetupPartyViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextView *descriptionInput;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateInput;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesForUploadCollectionView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation SetupPartyViewController

NSMutableArray *imagesForUploadData;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
    //NSData *flatImage = UIImageJPEGRepresentation(image, 0.1f);

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.descriptionInput scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO]; // Fixes problem: I can't type description after rotation
}
- (IBAction)datePickerAction:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSString *formatedDate = [dateFormatter stringFromDate:self.dateInput.date];
    
    NSLog(@"%@", formatedDate);
}

- (void)detectLocation {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [locations lastObject]);
    [manager stopUpdatingLocation];
}

- (IBAction)submitAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)validateFields {
    
    if(self.titleInput.text.length == 0) {
        
        return NO;
    }
    
    if(self.descriptionInput.text.length == 0) {
        
        return NO;
    }
    
    if(self.locationInput.text.length == 0) {
        
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

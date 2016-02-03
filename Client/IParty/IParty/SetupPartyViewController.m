//
//  SetupPartyViewController.m
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "SetupPartyViewController.h"
#import "UploadImageCollectionViewCell.h"

@interface SetupPartyViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *partyTitle;
@property (weak, nonatomic) IBOutlet UITextView *partyDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesForUploadCollectionView;

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
    NSLog(@"Clicked row: %ld col: %ld", (long)indexPath.row, (long)indexPath.section);
    
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
    [self.partyDescription scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (IBAction)submitButtonTouched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

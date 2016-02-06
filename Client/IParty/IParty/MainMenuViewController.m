//
//  ViewController.m
//  IParty
//
//  Created by Swifty on 2/2/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MainMenuItemCollectionViewCell.h"
#import "SetupPartyViewController.h"
#import "SendInviteViewController.h"

@interface MainMenuViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MainMenuViewController

static NSArray *image_array, *label_array, *segues_array;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    image_array = [NSArray arrayWithObjects: @"setupPartyImage.jpg", @"findPartyImage", @"sendInviteImage", @"reviewMemoriesImage", nil ];
    label_array = [NSArray arrayWithObjects: @"Setup Party", @"Find Party", @"Send Invite", @"History", nil];
    segues_array = [NSArray arrayWithObjects: @"setupPartyIdentifer", @"findPartyIdentifer", @"sendInviteIdentifer", @"reviewMemoriesIdentifer", nil];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    CGRect rect = self.collectionView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = [[UIScreen mainScreen] bounds].size.width;
    rect.size.height = [[UIScreen mainScreen] bounds].size.height;
    
    self.collectionView.frame = rect;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MainMenuItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCellIdentifer"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"setupPartyIdentifer"] && [segue.destinationViewController isKindOfClass:[SetupPartyViewController class]]) {
        
        SetupPartyViewController *spvc = (SetupPartyViewController *)segue.destinationViewController;
        spvc.token = self.token;
        
    } else if([segue.identifier isEqualToString:@"sendInviteIdentifer"] && [segue.destinationViewController isKindOfClass:[SendInviteViewController class]]) {
        
        SendInviteViewController *sivc = (SendInviteViewController *)segue.destinationViewController;
        sivc.token = self.token;
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CollectionCellIdentifer";
    
    UICollectionViewCell *originalCell = [cv dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    if(![originalCell isKindOfClass: [MainMenuItemCollectionViewCell class]] ||originalCell == nil) {
        originalCell = [[[NSBundle mainBundle] loadNibNamed:@"MainMenuItemCollectionViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    MainMenuItemCollectionViewCell *cell = (MainMenuItemCollectionViewCell*) originalCell;
    
    cell.label.text = [label_array objectAtIndex:(2 * indexPath.section) + indexPath.row];
    cell.image.image = [UIImage imageNamed: [image_array objectAtIndex:(2 * indexPath.section) + indexPath.row]];

    CALayer * layer = [cell layer];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowRadius:1.0];
    [layer setShadowColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f].CGColor];
    [layer setShadowOpacity:1.0];
    [layer setShadowPath:[[UIBezierPath bezierPathWithRect:cell.bounds] CGPath]];
    [layer setCornerRadius:20.0];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:[segues_array objectAtIndex:(2 * indexPath.section) + indexPath.row] sender:self];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize s = CGSizeMake(180, 130);
    /*
     if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
     return CGSizeMake(100, 100);
     }
     return CGSizeMake(200, 200); */
    return s;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 0, 0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

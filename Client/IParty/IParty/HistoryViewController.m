//
//  HistoryViewController.m
//  IParty
//
//  Created by Swifty on 2/4/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "AppDelegate.h"
#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "DBManager.h"
#import "ActionModel.h"
#import "MessageBox.h"
#import "UIView+Toast.h"

@interface HistoryViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *actions;

@property (weak, nonatomic) DBManager *dbManager;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.dbManager = delegate.globalDBManager;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"TableCellIdentifer"];
    
    [self loadData];
}

- (NSMutableArray *)actions {
    
    if(_actions == nil) {
        _actions = [[NSMutableArray alloc] init];
    }
    
    return _actions;
}

- (void)loadData {
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        NSString *query = [NSString stringWithFormat:@"select * from actions"];
        NSArray *actionsResult = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        
        for(int i = 0; i < [actionsResult count]; i++) {
            
            NSArray *entry = [actionsResult objectAtIndex:i];
            
            ActionModel *actionModel = [[ActionModel alloc] initWithTitle:[entry objectAtIndex:1] andWithDescription:[entry objectAtIndex:2]];
            [self.actions addObject:actionModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (IBAction)clearHistoryAction:(id)sender {
    
    id completion = ^(UIAlertAction *action) {
        if([[action title] isEqualToString:@"YES"] == YES) {

            NSString *deleteAll = [NSString stringWithFormat:@"delete from actions"];
            [self.dbManager executeQuery:deleteAll];
            
            self.actions = [[NSMutableArray alloc] init];
            
            [self.tableView reloadData];
            
            [self.view makeToast:@"History cleared"];
        }
    };
    
    [MessageBox showConfirmationBoxWithTitle:@"Attention" viewController:self completion:completion andMessage:@"Are sure you wanna clear all history ?"];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.actions count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *originalCell = [tableView dequeueReusableCellWithIdentifier:@"TableCellIdentifer"];
    
    if(![originalCell isKindOfClass: [HistoryTableViewCell class]] || originalCell == nil) {
        originalCell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    HistoryTableViewCell *cell = (HistoryTableViewCell *) originalCell;
    
    ActionModel *actionModel = self.actions[indexPath.row];
    
    cell.partyDescription.text = actionModel.pDescription;
    cell.partyTitle.text = actionModel.pTitle;
    
    return cell;
}

@end

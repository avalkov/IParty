//
//  HistoryTableViewCell.h
//  IParty
//
//  Created by Swifty on 2/7/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *partyDescription;
@property (weak, nonatomic) IBOutlet UILabel *partyTitle;

@end

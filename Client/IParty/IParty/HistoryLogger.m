//
//  HistoryLogger.m
//  IParty
//
//  Created by Swifty on 2/7/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import "HistoryLogger.h"

@implementation HistoryLogger

+(void)logActionToHistoryAtDbManager:(DBManager *) dbManager title:(NSString *) title andDescription:(NSString *) description {
    
    NSString *query = [NSString stringWithFormat:@"insert into actions values(null, '%@', '%@', '%@')", title, description, [[NSDate date] description]];
    [dbManager executeQuery:query];
}

@end

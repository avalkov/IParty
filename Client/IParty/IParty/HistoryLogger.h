//
//  HistoryLogger.h
//  IParty
//
//  Created by Swifty on 2/7/16.
//  Copyright © 2016 Swifty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBManager.h"

@interface HistoryLogger : NSObject

+(void)logActionToHistoryAtDbManager:(DBManager *) dbManager title:(NSString *) title andDescription:(NSString *) description;

@end

//
//  TBMigration.h
//  TBAquarium
//
//  Created by Kosuke Matsuda on 2014/03/27.
//  Copyright (c) 2014年 matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * const TBMigrationDidMigrateNotification;

@class FMDatabase;

@interface TBMigration : NSObject

+ (void)migrateWithDatabase:(FMDatabase *)database;

@end

@interface TBMigration (Protected)

- (BOOL)executeMigration:(NSString*)sql, ...;

@end

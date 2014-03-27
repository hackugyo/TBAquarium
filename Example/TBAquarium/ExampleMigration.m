//
//  ExampleMigration.m
//  TBAquarium
//
//  Created by Kosuke Matsuda on 2014/03/27.
//  Copyright (c) 2014年 matsuda. All rights reserved.
//

#import "ExampleMigration.h"

@implementation ExampleMigration

- (BOOL)migrateWithDatabaseVersion:(NSUInteger)version
{
    if (version < 1) {
        [self createTextTable];
        return YES;
    }
    return NO;
}

- (void)createTextTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS tests (primaryKey INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, createdAt REAL, updatedAt REAL)";
    [self executeMigration:sql];
}

@end

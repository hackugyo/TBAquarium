//
//  FMDatabase+TBAquarium.m
//  TBAquarium
//
//  Created by Kosuke Matsuda on 2014/03/27.
//  Copyright (c) 2014年 matsuda. All rights reserved.
//

#import "FMDatabase+TBAquarium.h"
#import "TBAquarium.h"

@implementation FMDatabase (TBAquarium)

- (NSArray *)columnsForTableName:(NSString *)tableName
{
    NSMutableArray *rows = [@[] mutableCopy];
    FMResultSet *resultSet = [self executeQuery:[NSString stringWithFormat:@"pragma table_info(%@)", tableName]];
    while ([resultSet next]) {
        [rows addObject:[resultSet resultDictionary]];
    }
    return [rows valueForKey:@"name"];
}

@end

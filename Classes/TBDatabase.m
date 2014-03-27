//
//  TBDatabase.m
//  TBAquarium
//
//  Created by Kosuke Matsuda on 2014/03/27.
//  Copyright (c) 2014年 matsuda. All rights reserved.
//

#import "TBAquarium.h"
#import "TBDatabase.h"

@implementation TBDatabase

+ (instancetype)databaseWithPath:(NSString *)inPath
{
    TBDatabase *db = [super databaseWithPath:inPath];
    [TBModel setDatabase:db];
    return db;
}

+ (instancetype)databaseWithFileName:(NSString *)fileName
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    return [self databaseWithPath:[documentDirectory stringByAppendingPathComponent:fileName]];
}

@end

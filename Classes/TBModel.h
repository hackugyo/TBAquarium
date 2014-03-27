//
//  TBModel.h
//  TBAquarium
//
//  Created by Kosuke Matsuda on 2014/03/27.
//  Copyright (c) 2014年 matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBDatabase.h"

@interface TBModel : NSObject

@property (nonatomic, assign) sqlite_int64  primaryKey;
@property (nonatomic, retain) NSDate     *createdAt;
@property (nonatomic, copy)   NSString   *errorMessage;

+ (NSString *)tableName;
+ (void)setDatabase:(FMDatabase *)database;
+ (NSArray *)findAll;
+ (NSArray *)findWithSql:(NSString *)sql withParameters:(NSArray *)parameters;
+ (NSArray *)findWithCondition:(NSString *)condition withParameters:(NSArray *)parameters;
+ (NSUInteger)count;

- (NSArray *)columnsWithoutPrimaryKey;
- (void)updateWithColumns:(NSArray *)columns;
- (void)save;
- (void)insert;
- (void)insertWithSql:(NSString *)sql withColumns:(NSArray *)columns;
- (void)insertWithSql:(NSString *)sql withValues:(NSArray *)values;
- (void)delete;
+ (void)deleteWithCondition:(NSString *)condition withParameters:(NSArray *)parameters;
+ (void)deleteAll;

- (BOOL)valid;

- (NSDate *)toLocalCreatedAt;

@end

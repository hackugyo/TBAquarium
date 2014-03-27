//
//  TBMigration.m
//  TBAquarium
//
//  Created by Kosuke Matsuda on 2014/03/27.
//  Copyright (c) 2014年 matsuda. All rights reserved.
//

#import "TBAquarium.h"
#import "TBMigration.h"
#import "FMDatabase.h"

NSString *TBMigrationDidMigrateNotification = @"TBMigrationDidMigrateNotification";

@interface FMDatabase ()
- (BOOL)executeUpdate:(NSString*)sql error:(NSError**)outErr withArgumentsInArray:(NSArray*)arrayArgs orDictionary:(NSDictionary *)dictionaryArgs orVAList:(va_list)args;
@end

@interface TBMigration ()
@property (readonly, nonatomic) FMDatabase *database;
@end

@implementation TBMigration

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use `migrateWithDatabase:` or `asyncMigrateWithDatabase:target:action:`"]
                                 userInfo:nil];
    return nil;
}

- (id)initWithDatabase:(FMDatabase *)database
{
    self = [super init];
    if (self) {
        _database = database;
    }
    return self;
}

+ (void)migrateWithDatabase:(FMDatabase *)database
{
    __block TBMigration *migration = [[self alloc] initWithDatabase:database];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        BOOL result = [migration migrate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TBMigrationDidMigrateNotification object:nil userInfo:@{@"result": @(result)}];
        });
    });
}

#pragma mark - Protected

- (BOOL)executeMigration:(NSString*)sql, ...
{
    va_list args;
    va_start(args, sql);

    BOOL result = [self.database executeUpdate:sql error:nil withArgumentsInArray:nil orDictionary:nil orVAList:args];

    va_end(args);
    return result;
}

#pragma mark - Private

- (BOOL)migrate
{
    @try {
        [self runMigrations:^BOOL(NSUInteger version) {
            return [self migrateWithDatabaseVersion:version];
        }];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

/*****
 // Migrations for database version 1 will run here
 if ([self databaseVersion] < 2) {
 [self createXXXTable];
 return YES;
 }
 *****/
- (BOOL)migrateWithDatabaseVersion:(NSUInteger)version
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    return NO;
}

- (NSArray *)tables
{
    NSMutableArray *rows = [@[] mutableCopy];
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM sqlite_master WHERE type = 'table'"];
    while ([resultSet next]) {
        [rows addObject:[resultSet resultDictionary]];
    }
    return rows;
}

- (NSArray *)tableNames
{
    return [[self tables] valueForKey:@"name"];
}

#pragma mark - run migrations

- (void)runMigrations:(BOOL (^)(NSUInteger version))block
{
    [self.database beginTransaction];

    [self.database executeQuery:@"PRAGMA foreign_keys = ON"];

    NSArray *tableNames = [self tableNames];
    if (![tableNames containsObject:@"applicationProperties"]) {
        [self createApplicationPropertiesTable];
    }

    NSUInteger version = [self databaseVersion];
    if (block) {
        BOOL isMigrated = block(version);
        if (isMigrated) {
            version++;
            [self setDatabaseVersion:version];
        }
    }

    [self.database commit];
}

- (void)createApplicationPropertiesTable
{
    [self executeMigration:@"CREATE TABLE applicationProperties (primaryKey INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, value INTEGER)"];
    [self executeMigration:@"INSERT INTO applicationProperties (name, value) VALUES('databaseVersion', 0)"];
}

- (void)updateApplicationProperty:(NSString *)propertyName value:(id)value
{
    [self executeMigration:@"UPDATE applicationProperties SET value = ? WHERE name = ?", value, propertyName, nil];
}

- (id)getApplicationProperty:(NSString *)propertyName
{
    NSMutableArray *rows = [@[] mutableCopy];
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT value FROM applicationProperties WHERE name = ?", propertyName, nil];

    while ([resultSet next]) {
        [rows addObject:[resultSet resultDictionary]];
    }
    if ([rows count] == 0) {
        return nil;
    }

    id object = [[rows lastObject] objectForKey:@"value"];
    if ([object isKindOfClass:[NSString class]]) {
        object = [NSNumber numberWithInteger:[(NSString *)object integerValue]];
    }
    return object;
}

- (void)setDatabaseVersion:(NSUInteger)version
{
    return [self updateApplicationProperty:@"databaseVersion" value:[NSNumber numberWithUnsignedInteger:version]];
}

- (NSUInteger)databaseVersion
{
    return [[self getApplicationProperty:@"databaseVersion"] unsignedIntegerValue];
}

@end

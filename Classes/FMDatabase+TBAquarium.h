//
//  FMDatabase+TBAquarium.h
//  TBAquarium
//
//  Created by Kosuke Matsuda on 2014/03/27.
//  Copyright (c) 2014年 matsuda. All rights reserved.
//

#import "FMDatabase.h"

@interface FMDatabase (TBAquarium)

- (NSArray *)columnsForTableName:(NSString *)tableName;

@end

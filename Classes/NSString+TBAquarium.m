//
//  NSString+TBAquarium.m
//  TBAquarium
//
//  Created by Kosuke Matsuda on 2014/03/27.
//  Copyright (c) 2014年 matsuda. All rights reserved.
//

#import "NSString+TBAquarium.h"

@implementation NSString (TBAquarium)

+ (NSArray *)tb_plurals
{
    static dispatch_once_t onceToken;
    static NSArray *_plurals = nil;
    dispatch_once(&onceToken, ^{
        _plurals = @[
                     @[@"(quiz)$"                   ,   @"$1zes"],
                     @[@"^(ox)$"                    ,   @"$1en"],
                     @[@"([m|l])ouse$"              ,   @"$1ice"],
                     @[@"(matr|vert|ind)(?:ix|ex)$" ,   @"$1ices"],
                     @[@"(x|ch|ss|sh)$"             ,   @"$1es"],
                     @[@"([^aeiouy]|qu)y$"          ,   @"$1ies"],
                     @[@"(hive)$"                   ,   @"$1s"],
                     @[@"(?:([^f])fe|([lr])f)$"     ,   @"$1$2ves"],
                     @[@"sis$"                      ,   @"ses"],
                     @[@"([ti])um$"                 ,   @"$1a"],
                     @[@"(buffal|tomat)o$"          ,   @"$1oes"],
                     @[@"(bu)s$"                    ,   @"$1ses"],
                     @[@"(alias|status)$"           ,   @"$1es"],
                     @[@"(octop|vir)us$"            ,   @"$1i"],
                     @[@"(ax|test)is$"              ,   @"$1es"],
                     @[@"s$"                        ,   @"s"],
                     @[@"$"                         ,   @"s"],
                     ];
    });
    return _plurals;
}

- (NSString *)tb_pluralizeString
{
    NSString *result = [self copy];
    @autoreleasepool {
        NSArray *plurals = [[self class] tb_plurals];
        for (NSArray *rules in plurals) {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:rules[0]
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            NSString *s = [regex stringByReplacingMatchesInString:self
                                                          options:NSMatchingReportCompletion
                                                            range:NSMakeRange(0, self.length)
                                                     withTemplate:rules[1]];
            if (![self isEqualToString:s]) {
                result = s;
                break;
            }
        }
    }
    return result;
}

@end

//
//  NSDate+Helper.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/28.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

- (NSDate *)resetTo0{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter dateFromString:[formatter stringFromDate:self]];
}

- (BOOL)isSameDayWith:(NSDate *)date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [[formatter stringFromDate:self] isEqualToString:[formatter stringFromDate:date]];
}

- (NSString *)dayTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"h:mm a";
    return [formatter stringFromDate:self];
}

- (NSString *)headerDisplay{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE, MMMM d";
    return [[formatter stringFromDate:self] uppercaseString];
}

- (NSString *)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    return [formatter stringFromDate:self];
}

@end

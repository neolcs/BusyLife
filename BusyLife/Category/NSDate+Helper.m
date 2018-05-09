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
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    return [calendar dateFromComponents:comps];
}

- (BOOL)isSameDayWith:(NSDate *)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    return [calendar isDate:self inSameDayAsDate:date];
}

- (BOOL)isToday {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    return [calendar isDateInToday:self];
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

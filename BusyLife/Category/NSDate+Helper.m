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
    formatter.dateFormat = @"YYYY-MM-DD";
    return [formatter dateFromString:[formatter stringFromDate:self]];
}

@end
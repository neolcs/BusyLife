//
//  BLEventViewModel.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/29.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLEventViewModel.h"
#import "NSDate+Helper.h"

@implementation BLEventViewModel

- (instancetype)initWithEvent:(BLEvent *)event {
    self = [super init];
    if (self) {
        _event = event;
    }
    return self;
}

- (NSString *)startTime {
    return [self.event.startDate dayTime];
}

- (NSString *)range {
    if (self.event.range > 24*60*60) {
        return @"24h+";
    }
    if (self.event.range < 60) {
        return @"1m-";
    }
    long hour = (long)(self.event.range) / 3600 ;
    long minute = (long)(self.event.range - hour * 3600)/ 60;
    NSMutableString* range = [NSMutableString string];
    if (hour > 0) {
        [range appendFormat:@"%ldh", hour];
        if (minute > 0) {
            [range appendString:@" "];
        }
    }
    if (minute > 0) {
        [range appendFormat:@"%ldm", minute];
    }
    return range;
}

- (UIColor *)typeColor {
    switch (self.event.type) {
        case 1:
            return [UIColor yellowColor];
            break;
        case 2:
            return [UIColor redColor];
        case 3:
            return [UIColor greenColor];
        default:
            break;
    }
    return [UIColor magentaColor];
}

- (NSString *)location {
    if (!self.event.location) {
        return nil;
    }
    
    NSMutableArray* parts = [NSMutableArray array];
    if (self.event.location.city) {
        [parts addObject:self.event.location.city];
    }
    if (self.event.location.name) {
        [parts addObject:self.event.location.name];
    }
    return [parts componentsJoinedByString:@", "];
}

@end

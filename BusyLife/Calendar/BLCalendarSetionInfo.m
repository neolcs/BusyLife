//
//  BLCalendarSetionInfo.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLCalendarSetionInfo.h"
#import "NSDate+Helper.h"

@implementation BLCalendarSetionInfo

@synthesize cellInfoArray = _cellInfoArray;

+ (BLCalendarSetionInfo *)current{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDate* now = [NSDate date];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:now];
    NSDate* startDate = [NSDate dateWithTimeInterval:(1-comp.weekday)*24*60*60 sinceDate:now];
    
    BLCalendarSetionInfo* calenderSectionInfo = [[BLCalendarSetionInfo alloc] initWithStartDate:startDate];
    return calenderSectionInfo;
}

- (instancetype)initWithStartDate:(NSDate *)startDate {
    self = [super init];
    if (self) {
        _startDate = [startDate resetTo0];
        
        NSMutableArray* tempArray = [NSMutableArray array];
        [tempArray addObject:startDate];
        self.cellInfoArray = tempArray;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:date];
    NSDate* startDate = [NSDate dateWithTimeInterval:(1-comp.weekday)*24*60*60 sinceDate:date];
    
    return [self initWithStartDate:startDate];
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[BLCalendarSetionInfo class]]) {
        return false;
    }
    
    BLCalendarSetionInfo* another = (BLCalendarSetionInfo *)object;
    return [self.startDate isEqual:another.startDate];
}

- (BLCalendarSetionInfo *)previous{
    NSDate* previousDate = [NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:self.startDate];
    BLCalendarSetionInfo* calenderSectionInfo = [[BLCalendarSetionInfo alloc] initWithStartDate:previousDate];
    return calenderSectionInfo;
}

- (BLCalendarSetionInfo *)next{
    NSDate* nextDate = [NSDate dateWithTimeInterval:7*24*60*60 sinceDate:self.startDate];
    BLCalendarSetionInfo* calenderSectionInfo = [[BLCalendarSetionInfo alloc] initWithStartDate:nextDate];
    return calenderSectionInfo;
}

@end

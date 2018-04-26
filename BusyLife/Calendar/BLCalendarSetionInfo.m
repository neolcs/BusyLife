//
//  BLCalendarSetionInfo.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLCalendarSetionInfo.h"
#import "BLCalendarCellInfo.h"

@implementation BLCalendarSetionInfo

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
        _startDate = startDate;
        
        BLCalendarCellInfo* cellInfo = [[BLCalendarCellInfo alloc] init];
        cellInfo.startDate = startDate;
        [self.cellInfoArray addObject:cellInfo];
    }
    return self;
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

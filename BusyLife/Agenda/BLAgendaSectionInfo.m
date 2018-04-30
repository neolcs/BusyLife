//
//  BLAgendaSectionInfo.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/29.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLAgendaSectionInfo.h"
#import "BLDataProvider.h"

@implementation BLAgendaSectionInfo

@synthesize cellInfoArray = _cellInfoArray;

+ (BLAgendaSectionInfo *)current {
    BLDateViewModel* dateVM = [[BLDataProvider sharedInstance] dateVMForDate:[NSDate date]];
    return [[BLAgendaSectionInfo alloc] initWithDateVM:dateVM];
}

- (instancetype)initWithDateVM:(BLDateViewModel *)dateVM{
    self = [super init];
    if (self) {
        _dateVM = dateVM;
    }
    return self;
}

- (NSArray *)cellInfoArray {
    if (self.dateVM.events && [self.dateVM.events count] > 0) {
        return self.dateVM.events;
    }
    NSMutableArray* nullArray = [NSMutableArray array];
    [nullArray addObject:[NSNull null]];
    return nullArray;
}

#pragma mark - BLSectionInfo
- (BLAgendaSectionInfo *)previous{
    NSDate* previousDate = [self.dateVM.date dateByAddingTimeInterval:-24*60*60];
    BLDateViewModel* dateVM = [[BLDataProvider sharedInstance] dateVMForDate:previousDate];
    return [[BLAgendaSectionInfo alloc] initWithDateVM:dateVM];
}
- (BLAgendaSectionInfo *)next{
    NSDate* previousDate = [self.dateVM.date dateByAddingTimeInterval:24*60*60];
    BLDateViewModel* dateVM = [[BLDataProvider sharedInstance] dateVMForDate:previousDate];
    return [[BLAgendaSectionInfo alloc] initWithDateVM:dateVM];
}

@end

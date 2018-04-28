//
//  BLCalendarSetionInfo.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLSectionInfo.h"

@interface BLCalendarSetionInfo : NSObject<BLSectionInfo>

@property (nonatomic, strong, readonly) NSDate* startDate;

- (instancetype)initWithStartDate:(NSDate *)startDate;

+ (BLCalendarSetionInfo *)current;

@end

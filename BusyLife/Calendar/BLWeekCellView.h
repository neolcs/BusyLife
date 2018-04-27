//
//  BLWeekCellView.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCalendarCellInfo.h"
#import "BLCellView.h"

@interface BLWeekCellView : BLCellView

- (instancetype)initWithCellInfo:(BLCalendarCellInfo *)cellInfo;

@end

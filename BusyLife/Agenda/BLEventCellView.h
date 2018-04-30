//
//  BLEventCellView.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/29.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEvent.h"
#import "BLEventViewModel.h"
#import "BLBorderView.h"

@interface BLEventCellView : BLBorderView

@property (nonatomic, readonly) BLEventViewModel* eventVM;

- (instancetype)initWithEvent:(BLEventViewModel *)eventVM;

@end

//
//  BLAgendaHeaderView.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/30.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLDateViewModel.h"
#import "BLBorderView.h"

@interface BLAgendaHeaderView : BLBorderView

- (instancetype)initWithDateVM:(BLDateViewModel *)dateVM;

@end

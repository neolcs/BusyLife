//
//  BLDayGridView.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/27.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLDateViewModel.h"

@interface BLDayGridView : UIView

@property (nonatomic, strong) BLDateViewModel* dateVM;

- (instancetype)initWithDateVM:(BLDateViewModel*)dateVM;

@end

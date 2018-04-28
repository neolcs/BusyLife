//
//  BLDataProvider.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/28.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLDateViewModel.h"

@interface BLDataProvider : NSObject

+ (BLDataProvider *)sharedInstance;

- (void)loadData;
- (BLDateViewModel *)dateVMForDate:(NSDate *)date;

@end

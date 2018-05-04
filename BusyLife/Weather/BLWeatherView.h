//
//  BLWeatherView.h
//  BusyLife
//
//  Created by ChuanLi on 2018/5/4.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLocation.h"

@interface BLWeatherView : UIView

- (void)displayWeatcherForDate:(NSDate *)date atLocation:(BLLocation *)location;

@end

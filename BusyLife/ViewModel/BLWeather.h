//
//  BLWeather.h
//  BusyLife
//
//  Created by ChuanLi on 2018/5/4.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLWeather : NSObject<NSSecureCoding>

@property (nonatomic, strong) NSDate* time;
@property (nonatomic, strong) NSString* summary;
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, assign) float temperatureMin;
@property (nonatomic, assign) float temperatureMax;

@end

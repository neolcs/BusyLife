//
//  BLDataProvider.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/28.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLDateViewModel.h"
#import "BLWeather.h"

@interface BLDataProvider : NSObject

@property (nonatomic, readonly) NSURLSession* session;
//@property (nonatomic, strong) NSDate* currentDate;
@property (nonatomic, strong) BLDateViewModel* currentDateVM;

+ (BLDataProvider *)sharedInstance;
- (void)loadData;


//Get the ViewModel for target date.
//search for the target VM from Array first, if not found, then expand the current ViewModel ArrayList cover the date.
//Currently, the dateVM array will increase infinitely, we will need to control the size later, maybe at the size of 365
- (BLDateViewModel *)dateVMForDate:(NSDate *)date;


//Weather data read and cache
- (BLWeather *)weatherForDate:(NSDate *)date;
- (void)saveWeather:(BLWeather *)weather;
- (void)saveWeatherArray:(NSArray *)weather;

@end

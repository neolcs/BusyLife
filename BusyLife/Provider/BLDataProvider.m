//
//  BLDataProvider.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/28.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLDataProvider.h"
#import "BLParser.h"
#import "BLEvent.h"
#import "NSDate+Helper.h"

@interface BLDataProvider()

@property (nonatomic, strong) NSMutableArray* eventArray;
@property (nonatomic, strong) NSMutableArray* dateVMArray;
@property (nonatomic, strong) NSDictionary* weatherDict;

- (NSDictionary *)_readCachedWeather;
- (void)_saveWeatherToCache:(NSDictionary *)dict;
- (NSString *)_cacheFilePath;
- (void)_fillDateVMWithRoundDate:(NSDate *)date;
- (void)_timezoneChanged:(NSNotification *)notif;

@end

@implementation BLDataProvider

+ (BLDataProvider *)sharedInstance{
    static BLDataProvider* gInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gInstance = [[BLDataProvider alloc] init];
    });
    return gInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateVMArray = [NSMutableArray array];
        self.eventArray = [NSMutableArray array];
        
        self.weatherDict = [self _readCachedWeather];
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_timezoneChanged:)
                                                     name:NSSystemTimeZoneDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)loadData{
    [self.dateVMArray removeAllObjects];
    [self.eventArray removeAllObjects];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"json"];
    NSData* jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError* err;
    NSArray* eventDictArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&err];
    if (nil == err) {
        BLParser* parser = [[BLParser alloc] init];
        for (NSDictionary* dict in eventDictArray) {
            BLEvent* event = [parser parseDict:dict toClass:NSClassFromString(@"BLEvent")];
            if (event) {
                [self.eventArray addObject:event];
            }
        }
    }
    
    BLDateViewModel* dateVM = [self dateVMForDate:[NSDate date]];
    self.currentDateVM = dateVM;
}

- (BLDateViewModel *)_biSearchDateVMForDate:(NSDate *)rawDate{
    NSDate* date = [rawDate resetTo0];
    if ([self.dateVMArray count] <= 0) {
        return nil;
    }
    if ([date compare:[(BLDateViewModel*)[self.dateVMArray objectAtIndex:0] date]] == NSOrderedAscending
        || [date compare:[(BLDateViewModel*)[self.dateVMArray lastObject] date]] == NSOrderedDescending) {
        return nil;
    }
   
    int i = 0;
    int j = (int)([self.dateVMArray count] - 1);
    while (i < j) {
        int k = (i + j) / 2;
        BLDateViewModel* dateVM = [self.dateVMArray objectAtIndex:k];
        NSComparisonResult result = [date compare:dateVM.date];
        if (result == NSOrderedAscending) {
            j = k - 1;
        }
        else if (result == NSOrderedDescending) {
            i = k + 1;
        }
        else {
            if ([dateVM.date isEqual:self.currentDateVM.date]) {
                dateVM.highlight = true;
            }
            return dateVM;
        }
    }
    BLDateViewModel* dateVM = [self.dateVMArray objectAtIndex:i];
    return dateVM;
}

- (BLDateViewModel *)dateVMForDate:(NSDate *)rawDate {
    NSDate* date = [rawDate resetTo0];
    if ([self.dateVMArray count] <= 0) {
        [self _fillDateVMWithRoundDate:date];
    }
    if ([date compare:[(BLDateViewModel*)[self.dateVMArray objectAtIndex:0] date]] == NSOrderedAscending
         || [date compare:[(BLDateViewModel*)[self.dateVMArray lastObject] date]] == NSOrderedDescending) {
        [self _fillDateVMWithRoundDate:date];
    }
    
    return [self _biSearchDateVMForDate:date];
}

- (void)setCurrentDateVM:(BLDateViewModel *)newDateVM {
    BLDateViewModel* dateVM = [self _biSearchDateVMForDate:newDateVM.date];
    if (nil == dateVM) {
        dateVM = newDateVM;
    }
    if ( _currentDateVM != nil && ![_currentDateVM.date isSameDayWith:dateVM.date]) {
        _currentDateVM.highlight = false;
    }
    _currentDateVM = dateVM;
    dateVM.highlight = true;
}

- (BLWeather *)weatherForDate:(NSDate *)date {
    return [self.weatherDict objectForKey:date];
}

- (void)saveWeather:(BLWeather *)weather{
    if (!weather) {
        return;
    }
    
    @synchronized(self){
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:self.weatherDict];
        [dict setObject:weather forKey:weather.time];
        self.weatherDict = dict;
        
        [self _saveWeatherToCache:self.weatherDict];
    }
}

- (void)saveWeatherArray:(NSArray *)weatherArray{
    @synchronized(self){
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        for (BLWeather *weather in weatherArray){
            if (![weather isKindOfClass:[BLWeather class]]) continue;
            [dict setObject:weather forKey:weather.time];
        }
        if ([dict count] <= 0) {
            return;
        }
        [dict addEntriesFromDictionary:self.weatherDict];
        self.weatherDict = dict;
        [self _saveWeatherToCache:self.weatherDict];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Method
- (void)_fillDateVMWithRoundDate:(NSDate *)date {
    NSDate* monthBefore = [date dateByAddingTimeInterval:-31*24*60*60];
    NSDate* monthAfter = [date dateByAddingTimeInterval:31*24*60*60];
    
    if ([self.dateVMArray count] > 0) {
        if ([monthBefore compare:[[self.dateVMArray lastObject] date]] == NSOrderedDescending
            || [monthAfter compare:[[self.dateVMArray objectAtIndex:0] date]] == NSOrderedAscending) {
            [self.dateVMArray removeAllObjects];
        }
    }

    NSDate* middleBefore = monthAfter;
    if ([self.dateVMArray count] > 0) {
        middleBefore = [[self.dateVMArray objectAtIndex:0] date];
    }
    
    middleBefore = [middleBefore dateByAddingTimeInterval:-24*60*60];

    int i = (int)([self.eventArray count] - 1);
    while ([middleBefore compare:monthBefore] != NSOrderedAscending) {
        BLDateViewModel* dateVM = [[BLDateViewModel alloc] initWithDate:middleBefore];
        NSMutableArray* eventArray = [NSMutableArray array];
        while (i >= 0) {
            BLEvent* event = [self.eventArray objectAtIndex:i];
            
            if ([[event.startDate resetTo0] compare:dateVM.date] == NSOrderedAscending) {
                break;
            }
            else if ([[event.startDate resetTo0] compare:dateVM.date] == NSOrderedSame) {
                [eventArray insertObject:event atIndex:0];
                i--;
            }
            else {
                i--;
            }
        }
        dateVM.events = eventArray;
        [self.dateVMArray insertObject:dateVM atIndex:0];
        middleBefore = [middleBefore dateByAddingTimeInterval:-24*60*60];
    }
    
    NSDate* middleAfter = [[self.dateVMArray lastObject] date];
    middleAfter = [middleAfter dateByAddingTimeInterval:24*60*60];
    int j = 0;
    while ([middleAfter compare:monthAfter] != NSOrderedDescending) {
        BLDateViewModel* dateVM = [[BLDateViewModel alloc] initWithDate:middleAfter];
        NSMutableArray* eventArray = [NSMutableArray array];
        while (j < [self.eventArray count]) {
            BLEvent* event = [self.eventArray objectAtIndex:j];
            
            if ([[event.startDate resetTo0] compare:dateVM.date] == NSOrderedDescending) {
                break;
            }
            else if([[event.startDate resetTo0] compare:dateVM.date] == NSOrderedSame) {
                [eventArray addObject:event];
                break;
            }
            else{
                j++;
            }
        }
        dateVM.events = eventArray;
        [self.dateVMArray addObject:dateVM];
        middleAfter = [middleAfter dateByAddingTimeInterval:24*60*60];
    }
}

- (void)_timezoneChanged:(NSNotification *)notif{
    [self.dateVMArray removeAllObjects];
}

- (NSString *)_cacheFilePath{
    NSArray* documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = documents[0];
    return [documentPath stringByAppendingPathComponent:@"weathers"];
}

- (NSDictionary *)_readCachedWeather{
    NSDictionary* weatherDict = [NSKeyedUnarchiver unarchiveObjectWithFile:[self _cacheFilePath]];
    return weatherDict;
}

- (void)_saveWeatherToCache:(NSDictionary *)dict{
    if (!dict) {
        return;
    }
    
    [NSKeyedArchiver archiveRootObject:dict toFile:[self _cacheFilePath]];
}

@end

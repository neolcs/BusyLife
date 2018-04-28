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

- (void)_fillDateVMWithDate:(NSDate *)date;
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
}

- (BLDateViewModel *)dateVMForDate:(NSDate *)rawDate {
    NSDate* date = [rawDate resetTo0];
    if ([self.dateVMArray count] <= 0) {
        [self _fillDateVMWithDate:date];
    }
    if ([date compare:[(BLDateViewModel*)[self.dateVMArray objectAtIndex:0] date]] == NSOrderedAscending
         || [date compare:[(BLDateViewModel*)[self.dateVMArray lastObject] date]] == NSOrderedDescending) {
        [self _fillDateVMWithDate:date];
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
            return dateVM;
        }
    }
    return [self.dateVMArray objectAtIndex:i];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Method
- (void)_fillDateVMWithDate:(NSDate *)date {
    NSDate* monthBefore = [[date dateByAddingTimeInterval:-31*24*60*60] resetTo0];
    NSDate* monthAfter = [[date dateByAddingTimeInterval:31*24*60*60] resetTo0];
    
    if ([self.dateVMArray count] > 0) {
        if ([monthBefore compare:[[self.dateVMArray lastObject] date]] == NSOrderedDescending
            || [monthAfter compare:[[self.dateVMArray objectAtIndex:0] date]] == NSOrderedAscending) {
            [self.dateVMArray removeAllObjects];
        }
    }

    NSDate* middleBefore = monthAfter;
    if ([self.dateVMArray count] > 0) {
        middleBefore = [[[self.dateVMArray objectAtIndex:0] date] resetTo0];
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
    
    NSDate* middleAfter = [[[self.dateVMArray lastObject] date] resetTo0];
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

@end

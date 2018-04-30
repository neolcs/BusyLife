//
//  BLDateViewModel.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/27.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLDateViewModel.h"
#import "NSDate+Helper.h"

@interface BLDateViewModel()

- (void)_highlightChanged:(NSNotification *)notif;

@end

@implementation BLDateViewModel

- (instancetype)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _date = date;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_highlightChanged:) name:BLDayGridViewHighlight object:nil];
    }
    return self;
}

- (NSString *)title{
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSInteger day = [calender component:NSCalendarUnitDay fromDate:self.date];
    if (day != 1 || self.highlight) {
        return [NSString stringWithFormat:@"%ld", day];
    }
    else{
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM";
        return [NSString stringWithFormat:@"%@\n%ld", [formatter stringFromDate:self.date], day];
    }
}

- (int)lineNumber {
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSInteger day = [calender component:NSCalendarUnitDay fromDate:self.date];
    return day == 1 ? 2 : 1;
}

- (UIColor *)backColor{
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSInteger month = [calender component:NSCalendarUnitMonth fromDate:self.date];
    return month % 2 == 0 ? [UIColor whiteColor] : [UIColor colorWithWhite:0.8 alpha:0.5];
}

- (UIColor *)dayBackColor {
    return self.highlight ? [UIColor blueColor] : [UIColor clearColor];
}

- (UIColor *)dayTextColor {
    return self.highlight ? [UIColor whiteColor] : [UIColor darkGrayColor];
}

- (NSString *)headerTitle {
    NSMutableString* title = [NSMutableString string];
    if ([[self.date resetTo0] isEqual:[[NSDate date] resetTo0]]) {
        [title appendString:@"TODAY \u2022 "];
    }
    return [title stringByAppendingString:[self.date headerDisplay]];
}

- (UIColor *)headerTitleColor {
    if ([[self.date resetTo0] isEqual:[[NSDate date] resetTo0]]) {
        return [UIColor magentaColor];
    }
    return [UIColor lightGrayColor];
}

- (void)setHighlight:(BOOL)highlight {
    if (highlight == _highlight) return;
    
    _highlight = highlight;
    self.updateHandler();
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:NSClassFromString(@"BLDateViewModel")]) {
        return false;
    }
    BLDateViewModel* another = (BLDateViewModel *)object;
    return [self.date isEqual:another.date];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Method
- (void)_highlightChanged:(NSNotification *)notif{
    if ([self isEqual:notif.object]) {
        self.highlight = YES;
    }
    else{
        self.highlight = NO;
    }
}

@end

//
//  BLCalendarHeaderView.m
//  BusyLife
//
//  Created by ChuanLi on 2018/5/1.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLCalendarHeaderView.h"

@interface BLCalendarHeaderView()

@property (nonatomic, strong) NSArray* weekdayArray;

- (void)_addViews;
- (void)_addConstraints;

@end

@implementation BLCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth = 1.f;
        self.borderColor = [UIColor lightGrayColor];
        
        [self _addViews];
        [self _addConstraints];
    }
    return self;
}

#pragma mark - Private
- (void)_addViews {
    NSMutableArray* weekdayArray = [NSMutableArray array];
    NSArray* names = @[@"S", @"M", @"T", @"W", @"T", @"F", @"S"];
    for (int i = 0; i < 7; ++i) {
        UILabel* weekdayView = [[UILabel alloc] init];
        weekdayView.translatesAutoresizingMaskIntoConstraints = false;
        weekdayView.text = names[i];
        weekdayView.textColor = [UIColor lightGrayColor];
        weekdayView.font = [UIFont systemFontOfSize:12.f];
        weekdayView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:weekdayView];
        [weekdayArray addObject:weekdayView];
    }
    self.weekdayArray = weekdayArray;
}

- (void)_addConstraints {
    for (int i = 0; i < [self.weekdayArray count]; ++i) {
        UIView* weekdayView = [self.weekdayArray objectAtIndex:i];
        if (i == 0) {
            [weekdayView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
        }
        else{
            UIView* prev = [self.weekdayArray objectAtIndex:i-1];
            [weekdayView.leadingAnchor constraintEqualToAnchor:prev.trailingAnchor].active = true;
            [weekdayView.widthAnchor constraintEqualToAnchor:prev.widthAnchor].active = true;
        }
        if (i == [self.weekdayArray count] - 1){
            [weekdayView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor].active = true;
        }
        
        [weekdayView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
        [weekdayView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    }
}

@end

//
//  BLWeekCellView.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLWeekCellView.h"
#import "BLDayGridView.h"
#import "BLDateViewModel.h"
#import "BLDataProvider.h"

@interface BLWeekCellView()

@property (nonatomic, strong) UIView* borderView;
@property (nonatomic, strong) NSMutableArray* gridArray;

- (void)_addContraints;

@end

@implementation BLWeekCellView

- (instancetype)initWithCellInfo:(BLCalendarCellInfo *)cellInfo {
    if (!cellInfo) return nil;
    
    self = [super init];
    if (self) {
        self.cellInfo = cellInfo;
        
        self.gridArray = [NSMutableArray array];
        
        for (int i = 0; i < 7; ++i) {
            NSDate* date = [cellInfo.startDate dateByAddingTimeInterval:i*24*60*60];
            BLDateViewModel* dateVM = [[BLDataProvider sharedInstance] dateVMForDate:date];
            BLDayGridView* dayGridView = [[BLDayGridView alloc] initWithDateVM:dateVM];
            [self addSubview:dayGridView];
            [self.gridArray addObject:dayGridView];
        }
        
        UIView* borderView = [[UIView alloc] init];
        borderView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        borderView.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:borderView];
        self.borderView = borderView;
        
        [self _addContraints];
    }
    return self;
}

- (void)_addContraints {
    for (int i = 0; i < [self.gridArray count]; ++i) {
        BLDayGridView* dayGridView = [self.gridArray objectAtIndex:i];
        if (i == 0) {
            [dayGridView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
        }
        else{
            BLDayGridView* prev = [self.gridArray objectAtIndex:i-1];
            [dayGridView.leadingAnchor constraintEqualToAnchor:prev.trailingAnchor].active = true;
            [dayGridView.widthAnchor constraintEqualToAnchor:prev.widthAnchor].active = true;
        }
        if (i == [self.gridArray count] - 1){
            [dayGridView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor].active = true;
        }
        
        [dayGridView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
        [dayGridView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    }
    
    [self.borderView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
    [self.borderView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = true;
    [self.borderView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    [self.borderView.heightAnchor constraintEqualToConstant:0.5].active = true;
}

@end

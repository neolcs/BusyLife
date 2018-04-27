//
//  ViewController.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLViewController.h"
#import "BLScrollView.h"
#import "BLNumberInfo.h"
#import "BLNumberCellView.h"
#import "BLScrollView/BLNumberSectionInfo.h"
#import "UIView+Common.h"

#import "Calendar/BLCalendarSetionInfo.h"
#import "Calendar/BLCalendarCellInfo.h"
#import "Calendar/BLWeekCellView.h"

@interface BLViewController ()<BLScrollViewDelegate, BLScrollViewDataSource>

@end

@implementation BLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BLScrollView* scrollView = [[BLScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor cyanColor];
    scrollView.delegate = self;
    scrollView.dataSource = self;
    scrollView.topSectionInfo = [BLCalendarSetionInfo current];
    [scrollView reloadData];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - BLScrollViewDelegate
- (void)cellWillBeRemoved:(BLCellView *)cell{
}

#pragma mark - BLScrollViewDataSource
- (BLCellView *)scrollView:(BLScrollView *)scrollView cellForInfo:(BLCellInfo *)cellInfo{
    if ([cellInfo isKindOfClass:NSClassFromString(@"BLCalendarCellInfo")]) {
        BLCalendarCellInfo* calendarInfo = (BLCalendarCellInfo *)cellInfo;
        BLWeekCellView* cellView = [[BLWeekCellView alloc] initWithCellInfo:calendarInfo];
        cellView.height = 40.f;
        cellView.width = self.view.width;
        return cellView;
    }
    return nil;
}

- (UIView *)scrollView:(BLScrollView *)scrollView headerForInfo:(BLSectionInfo *)sectionInfo{
    return nil;
}

@end

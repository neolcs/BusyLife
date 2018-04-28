//
//  ViewController.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLViewController.h"
#import "BLScrollView.h"

#import "UIView+Common.h"

#import "Calendar/BLCalendarSetionInfo.h"
#import "Calendar/BLCalendarCellInfo.h"
#import "Calendar/BLWeekCellView.h"

#import "BLDataProvider.h"

@interface BLViewController ()<BLScrollViewDelegate, BLScrollViewDataSource>

@end

@implementation BLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BLDataProvider sharedInstance] loadData];
    
    BLScrollView* scrollView = [[BLScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 160.f)];
    [self.view addSubview:scrollView];
    scrollView.clipsToBounds = YES;
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

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
#import "Calendar/BLWeekCellView.h"
#import "BLDataProvider.h"

@interface BLViewController ()<BLScrollViewDelegate, BLScrollViewDataSource>

@property (nonatomic, strong) BLScrollView* calendarView;

@end

@implementation BLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BLDataProvider sharedInstance] loadData];
    
    BLScrollView* calendarView = [[BLScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 160.f)];
    self.calendarView = calendarView;
    [self.view addSubview:calendarView];
    calendarView.clipsToBounds = YES;
    calendarView.delegate = self;
    calendarView.dataSource = self;
    calendarView.topSectionInfo = [BLCalendarSetionInfo current];
    
    [calendarView reloadData];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - BLScrollViewDelegate
- (void)cellWillBeRemoved:(UIView *)cell{
}

#pragma mark - BLScrollViewDataSource
- (UIView *)scrollView:(BLScrollView *)scrollView cellForInfo:(id)object{
    if ( scrollView == self.calendarView && [object isKindOfClass:[NSDate class]]) {
        BLWeekCellView* cellView = [[BLWeekCellView alloc] initWithStartDate:object];
        cellView.height = 40.f;
        cellView.width = self.view.width;
        return cellView;
    }
    return nil;
}

- (UIView *)scrollView:(BLScrollView *)scrollView headerForInfo:(id<BLSectionInfo>)sectionInfo{
    return nil;
}

@end

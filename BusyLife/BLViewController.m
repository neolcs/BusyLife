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
#import "BLAgendaSectionInfo.h"
#import "BLDataProvider.h"
#import "BLEventCellView.h"
#import "BLNullEventCellView.h"
#import "BLAgendaHeaderView.h"
#import "BLCalendarHeaderView.h"

@interface BLViewController ()<BLScrollViewDelegate, BLScrollViewDataSource>

@property (nonatomic, strong) BLScrollView* calendarView;
@property (nonatomic, strong) BLScrollView* agendaView;

- (void)_currentDateVMChanged:(NSNotification *)notif;

@end

@implementation BLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BLDataProvider sharedInstance] loadData];
    
    BLCalendarHeaderView* calendarHeaderView = [[BLCalendarHeaderView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 40.f)];
    [self.view addSubview:calendarHeaderView];
    
    BLScrollView* calendarView = [[BLScrollView alloc] initWithFrame:CGRectMake(0, calendarHeaderView.bottom, self.view.width, 160.f)];
    [self.view addSubview:calendarView];
    calendarView.clipsToBounds = YES;
    calendarView.delegate = self;
    calendarView.dataSource = self;
    calendarView.topSectionInfo = [BLCalendarSetionInfo current];
    self.calendarView = calendarView;
    
    BLScrollView* agendaView = [[BLScrollView alloc] initWithFrame:CGRectMake(0, calendarView.bottom, self.view.width, 300.f)];
    agendaView.clipsToBounds = YES;
    agendaView.delegate = self;
    agendaView.dataSource = self;
    agendaView.topSectionInfo = [BLAgendaSectionInfo current];
    [self.view addSubview:agendaView];
    self.agendaView = agendaView;
    
    [self.calendarView reloadData];
    [self.agendaView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_currentDateVMChanged:)
                                                 name:BLDayGridViewHighlight
                                               object:nil];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - BLScrollViewDelegate
- (void)cellWillBeRemoved:(UIView *)cell{
}

- (void)scrollView:(BLScrollView *)scrollView topSectionChanged:(id<BLSectionInfo>)sectionInfo {
    if (scrollView == self.agendaView) {
        BLAgendaSectionInfo* agendaSectionInfo = (BLAgendaSectionInfo *)sectionInfo;
        [[NSNotificationCenter defaultCenter] postNotificationName:BLDayGridViewHighlight object:agendaSectionInfo.dateVM];
    }
}

#pragma mark - BLScrollViewDataSource
- (UIView *)scrollView:(BLScrollView *)scrollView cellForInfo:(id)object{
    if ( scrollView == self.calendarView && [object isKindOfClass:[NSDate class]] ) {
        BLWeekCellView* cellView = [[BLWeekCellView alloc] initWithStartDate:object];
        cellView.height = 40.f;
        cellView.width = self.view.width;
        return cellView;
    }
    if ( scrollView == self.agendaView) {
        if ([object isKindOfClass:[BLEvent class]]) {
            BLEventViewModel* eventVM = [[BLEventViewModel alloc] initWithEvent:object];
            BLEventCellView* eventCellView = [[BLEventCellView alloc] initWithEvent:eventVM];
            eventCellView.width = self.view.width;
            eventCellView.height = 90.f;
            return eventCellView;
        }
        else if ([object isKindOfClass:[NSNull class]]) {
            BLNullEventCellView* nullEventCellView = [[BLNullEventCellView alloc] init];
            nullEventCellView.width = self.view.width;
            nullEventCellView.height = 30.f;
            return nullEventCellView;
        }
        else{
            return nil;
        }
    }
    return nil;
}

- (UIView *)scrollView:(BLScrollView *)scrollView headerForInfo:(id<BLSectionInfo>)sectionInfo{
    if (scrollView == self.agendaView && [sectionInfo isKindOfClass:[BLAgendaSectionInfo class]]) {
        BLAgendaSectionInfo* agendaSI = (BLAgendaSectionInfo *)sectionInfo;
        BLAgendaHeaderView* header = [[BLAgendaHeaderView alloc] initWithDateVM:agendaSI.dateVM];
        header.width = self.view.width;
        header.height = 30.f;
        return header;
    }
    return nil;
}

#pragma mark - Private
- (void)_currentDateVMChanged:(NSNotification *)notif{
    if ([notif.name isEqualToString:BLDayGridViewHighlight]
        && [notif.object isKindOfClass:[BLDateViewModel class]]) {
        BLDateViewModel* dateVM = (BLDateViewModel *)notif.object;
        BLAgendaSectionInfo* sectionInfo = [[BLAgendaSectionInfo alloc] initWithDateVM:dateVM];
        self.agendaView.topSectionInfo = sectionInfo;
    }
}

@end

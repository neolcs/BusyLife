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
#import "BLCalendarSetionInfo.h"
#import "BLWeekCellView.h"
#import "BLAgendaSectionInfo.h"
#import "BLDataProvider.h"
#import "BLEventCellView.h"
#import "BLNullEventCellView.h"
#import "BLAgendaHeaderView.h"
#import "BLCalendarHeaderView.h"

#import "NSDate+Helper.h"

@interface BLViewController ()<BLScrollViewDelegate, BLScrollViewDataSource>

@property (nonatomic, strong) BLScrollView* calendarView;
@property (nonatomic, strong) BLScrollView* agendaView;
@property (nonatomic, strong) BLCalendarHeaderView* calendarHeaderView;
@property (nonatomic, strong) UIButton* locateBtn;

@property (nonatomic, strong) NSLayoutConstraint* foldLayout;
@property (nonatomic, strong) NSLayoutConstraint* expandLayout;

- (void)_currentDateVMChanged:(NSNotification *)notif;
- (void)_addViews;
- (void)_addConstraints;
- (void)_locate:(UIButton *)btn;

@end

@implementation BLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BLDataProvider sharedInstance] loadData];
    
    [self _addViews];
    [self _addConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_currentDateVMChanged:)
                                                 name:BLDayGridViewHighlight
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.calendarView reloadData];
    [self.agendaView reloadData];
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
//CalendarView should fully display every cell of week. If not, adjust the offset to commit it.
- (void)scrollViewDidStopScroll:(BLScrollView *)scrollView {
    if (scrollView == self.calendarView) {
        BLSectionView* topSection = [scrollView.sectionViewArray objectAtIndex:0];
        if (topSection.fullExpanded) {
            return;
        }
        
        CGFloat distance = topSection.height < topSection.fullHeight - topSection.height ? -topSection.height :  (topSection.fullHeight - topSection.height);
        [scrollView scrollOffset:CGPointMake(0, distance) animated:true];
    }
}

- (void)scrollViewDidStartScroll:(BLScrollView *)scrollView {
    if (self.calendarView == scrollView) {      //expand calendar view
        self.foldLayout.active = false;
        self.expandLayout.active = true;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    if (self.agendaView == scrollView) {        //fold calendar view
        self.expandLayout.active = false;
        self.foldLayout.active = true;
        
        //CalendarView will fold up.If the current date is in the top 2 rows of the CalendarView, change the CalendarView's topSection.
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            BLAgendaSectionInfo* agendaSectionInfo = [self.agendaView currentSection];
            BLCalendarSetionInfo* calendarSectionInfo = [self.calendarView currentSection];
            NSTimeInterval interval = [agendaSectionInfo.dateVM.date timeIntervalSinceDate:calendarSectionInfo.startDate];
            if (interval < 0 || interval > 13*24*60*60) {
                BLCalendarSetionInfo* sectionInfo = [[BLCalendarSetionInfo alloc] initWithDate:agendaSectionInfo.dateVM.date];
                self.calendarView.topSectionInfo = sectionInfo;
            }
            else {
                [self.calendarView reloadData];
            }
        }];
    }
}

- (void)scrollView:(BLScrollView *)scrollView sectionWillBeRemoved:(id<BLSectionInfo>)sectionInfo{
    //TODO: add logic here to deal with removement of a section
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
        return cellView;
    }
    if ( scrollView == self.agendaView) {
        if ([object isKindOfClass:[BLEvent class]]) {
            BLEventViewModel* eventVM = [[BLEventViewModel alloc] initWithEvent:object];
            BLEventCellView* eventCellView = [[BLEventCellView alloc] initWithEvent:eventVM];
            return eventCellView;
        }
        else if ([object isKindOfClass:[NSNull class]]) {
            BLNullEventCellView* nullEventCellView = [[BLNullEventCellView alloc] init];
            return nullEventCellView;
        }
        else{
            return nil;
        }
    }
    return nil;
}

- (CGFloat)scrollView:(BLScrollView *)scrollView cellHeightForInfo:(id)cellInfo {
    if ( scrollView == self.calendarView && [cellInfo isKindOfClass:[NSDate class]] ) {
        return 40.f;
    }
    if ( scrollView == self.agendaView) {
        if ([cellInfo isKindOfClass:[BLEvent class]]) {
            return 90.f;
        }
        else if ([cellInfo isKindOfClass:[NSNull class]]) {
            return 30.f;
        }
        else{
            return 0.f;
        }
    }
    return 0.f;
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
        
        [BLDataProvider sharedInstance].currentDateVM = dateVM;
        
        BLAgendaSectionInfo* sectionInfo = [[BLAgendaSectionInfo alloc] initWithDateVM:dateVM];
        self.agendaView.topSectionInfo = sectionInfo;
        
        BLCalendarSetionInfo* calendarSectionInfo = [[BLCalendarSetionInfo alloc] initWithDate:dateVM.date];
        for (BLSectionView* sectionView in self.calendarView.sectionViewArray) {
            if ([sectionView.sectionInfo isEqual:calendarSectionInfo]) {
                return;
            }
        }
        self.calendarView.topSectionInfo = calendarSectionInfo;
    }
}

- (void)_addViews {
    BLCalendarHeaderView* calendarHeaderView = [[BLCalendarHeaderView alloc] init];
    calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:calendarHeaderView];
    self.calendarHeaderView = calendarHeaderView;
    
    BLScrollView* calendarView = [[BLScrollView alloc] init];
    calendarView.accessibilityIdentifier = @"calendarView";
    calendarView.tag = 0;
    calendarView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:calendarView];
    calendarView.clipsToBounds = true;
    calendarView.delegate = self;
    calendarView.dataSource = self;
    calendarView.topSectionInfo = [BLCalendarSetionInfo current];
    self.calendarView = calendarView;
    
    BLScrollView* agendaView = [[BLScrollView alloc] init];
    agendaView.accessibilityIdentifier = @"agendaView";
    agendaView.tag = 1;
    agendaView.translatesAutoresizingMaskIntoConstraints = false;
    agendaView.clipsToBounds = true;
    agendaView.delegate = self;
    agendaView.dataSource = self;
    agendaView.topSectionInfo = [BLAgendaSectionInfo current];
    [self.view addSubview:agendaView];
    self.agendaView = agendaView;
    
    UIButton* locateBtn = [[UIButton alloc] init];
    locateBtn.translatesAutoresizingMaskIntoConstraints = false;
    [locateBtn setBackgroundImage:[UIImage imageNamed:@"locate"] forState:UIControlStateNormal];
    [locateBtn addTarget:self action:@selector(_locate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locateBtn];
    self.locateBtn = locateBtn;
}

- (void)_addConstraints {
    [self.calendarHeaderView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20.f].active = true;
    [self.calendarHeaderView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.calendarHeaderView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.calendarHeaderView.heightAnchor constraintEqualToConstant:40.f].active = true;
    
    [self.calendarView.topAnchor constraintEqualToAnchor:self.calendarHeaderView.bottomAnchor].active = true;
    [self.calendarView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.calendarView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    self.foldLayout = [self.calendarView.heightAnchor constraintEqualToConstant:80.f];
    self.expandLayout = [self.calendarView.heightAnchor constraintEqualToConstant:240.f];
    
    [self.agendaView.topAnchor constraintEqualToAnchor:self.calendarView.bottomAnchor].active = true;
    [self.agendaView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.agendaView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.agendaView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    
    [self.locateBtn.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20.f].active = true;
    [self.locateBtn.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-20.f].active = true;
    [self.locateBtn.widthAnchor constraintEqualToConstant:30.f].active = true;
    [self.locateBtn.heightAnchor constraintEqualToConstant:30.f].active = true;
    
    self.foldLayout.active = true;
}

//Go back to today
- (void)_locate:(UIButton *)btn{
    BLDateViewModel* dateVM = [[BLDateViewModel alloc] initWithDate:[[NSDate date] resetTo0]];
    NSNotification* notif = [NSNotification notificationWithName:BLDayGridViewHighlight object:dateVM];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

@end

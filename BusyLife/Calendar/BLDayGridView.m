//
//  BLDayGridView.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/27.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLDayGridView.h"
#import "UIView+Common.h"


@interface BLDayGridView()

@property (nonatomic, strong) UILabel* monthDay;
@property (nonatomic, strong) UIView* dot;

- (void)_addConstraints;
- (void)_updateDayGrid;
- (void)_addGesture;
- (void)_tapMe:(UITapGestureRecognizer *)tap;

@end

#define BLDayGridDaySize   (40.f)
#define BLDayGridDotSize    (5.f)

@implementation BLDayGridView

- (instancetype)initWithDateVM:(BLDateViewModel*)dateVM{
    self = [super init];
    if (self) {
        _dateVM = dateVM;
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        UILabel* monthDay = [[UILabel alloc] init];
        monthDay.translatesAutoresizingMaskIntoConstraints = false;
        monthDay.backgroundColor = [UIColor clearColor];
        monthDay.clipsToBounds = YES;
        monthDay.textAlignment = NSTextAlignmentCenter;
      
        [self addSubview:monthDay];
        self.monthDay = monthDay;
        
        UIView* dot = [[UIView alloc] init];
        dot.translatesAutoresizingMaskIntoConstraints = false;
        dot.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:dot];
        self.dot = dot;
        
        [self _addConstraints];
        [self _updateDayGrid];
        [self _addGesture];
    }
    return self;
}

- (void)_addConstraints{
    [self.monthDay.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
    [self.monthDay.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;
    [self.monthDay.widthAnchor constraintEqualToConstant:BLDayGridDaySize].active = true;
    [self.monthDay.heightAnchor constraintEqualToConstant:BLDayGridDaySize].active = true;
    
    [self.dot.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
    [self.dot.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5.f].active = true;
    [self.dot.widthAnchor constraintEqualToConstant:BLDayGridDotSize].active = true;
    [self.dot.heightAnchor constraintEqualToConstant:BLDayGridDotSize].active = true;
}

- (void)_updateDayGrid{    
    __weak typeof(self) weakSelf = self;
    self.dateVM.updateHandler = ^{
        weakSelf.monthDay.numberOfLines = weakSelf.dateVM.lineNumber;
        weakSelf.monthDay.font = weakSelf.dateVM.lineNumber == 1 ? [UIFont systemFontOfSize:14.f] : [UIFont systemFontOfSize:12.f];
        weakSelf.monthDay.text = weakSelf.dateVM.title;
        weakSelf.backgroundColor = weakSelf.dateVM.backColor;
        
        weakSelf.monthDay.backgroundColor = weakSelf.dateVM.dayBackColor;
        weakSelf.monthDay.textColor = weakSelf.dateVM.dayTextColor;
    };
    
    self.dateVM.updateHandler();
}

- (void)_addGesture {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapMe:)];
    [self addGestureRecognizer:tap];
}

- (void)_tapMe:(UITapGestureRecognizer *)tap{
    NSNotification* notif = [NSNotification notificationWithName:BLDayGridViewHighlight object:self.dateVM];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.monthDay.layer.cornerRadius = self.monthDay.width/2.f;
    self.dot.layer.cornerRadius = self.dot.width/2.f;
}

@end

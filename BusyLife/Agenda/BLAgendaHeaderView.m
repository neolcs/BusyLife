//
//  BLAgendaHeaderView.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/30.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLAgendaHeaderView.h"

@interface BLAgendaHeaderView()

@property (nonatomic, strong) BLDateViewModel* dateVM;

@end

@implementation BLAgendaHeaderView

- (instancetype)initWithDateVM:(BLDateViewModel *)dateVM {
    self = [super init];
    if (self) {
        self.dateVM = dateVM;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel* label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.font = [UIFont systemFontOfSize:12.f];
        label.text = self.dateVM.headerTitle;
        label.textColor = self.dateVM.headerTitleColor;
        [self addSubview:label];
        
        [label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:7.f].active = true;
        [label.topAnchor constraintEqualToAnchor:self.topAnchor constant:2.f].active = true;
        [label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-7.f].active = true;
        [label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-2.f].active = true;
        
        UIView* borderView = [[UIView alloc] init];
        borderView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        borderView.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:borderView];
        
        [borderView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
        [borderView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = true;
        [borderView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
        [borderView.heightAnchor constraintEqualToConstant:0.5].active = true;
    }
    return self;
}

@end

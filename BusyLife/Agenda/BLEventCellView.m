//
//  BLEventCellView.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/29.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLEventCellView.h"
#import "BLAttender.h"
#import "UIView+Common.h"

@interface BLEventCellView()

@property (nonatomic, strong) UILabel* startLabel;
@property (nonatomic, strong) UILabel* rangeLabel;
@property (nonatomic, strong) UIView* typeView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) NSArray* attenderArray;
@property (nonatomic, strong) UIImageView* anchorView;
@property (nonatomic, strong) UIView* iconBackView;
@property (nonatomic, strong) UILabel* locationLabel;

- (void)_addViews;
- (void)_addConstraints;

@end

@implementation BLEventCellView

- (instancetype)initWithEvent:(BLEventViewModel *)eventVM {
    self = [super init];
    if (self) {
        _eventVM = eventVM;
        
        
        self.borderWidth = 1.f;
        self.borderColor = [UIColor lightGrayColor];
        
        [self _addViews];
        [self _addConstraints];
    }
    return self;
}

#pragma mark - Private
- (void)_addViews {
    UILabel* startLabel = [[UILabel alloc] init];
    startLabel.translatesAutoresizingMaskIntoConstraints = false;
    startLabel.font = [UIFont systemFontOfSize:12.f];
    startLabel.textColor = [UIColor darkGrayColor];
    startLabel.text = self.eventVM.startTime;
    [self addSubview:startLabel];
    self.startLabel = startLabel;
    
    UILabel* rangeLabel = [[UILabel alloc] init];
    rangeLabel.translatesAutoresizingMaskIntoConstraints = false;
    rangeLabel.font = [UIFont systemFontOfSize:12.f];
    rangeLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    rangeLabel.text = self.eventVM.range;
    [self addSubview:rangeLabel];
    self.rangeLabel = rangeLabel;
    
    UIView* typeView = [[UIView alloc] init];
    typeView.translatesAutoresizingMaskIntoConstraints = false;
    typeView.backgroundColor = self.eventVM.typeColor;
    [self addSubview:typeView];
    self.typeView = typeView;
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    titleLabel.text = self.eventVM.event.title;
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView* iconBackView = [[UIView alloc] init];
    iconBackView.translatesAutoresizingMaskIntoConstraints = false;
    iconBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:iconBackView];
    self.iconBackView = iconBackView;
    
    NSMutableArray* attenderArray = [NSMutableArray array];
    for (BLAttender* attender in self.eventVM.event.attends){
        UIImageView* iconView = [[UIImageView alloc] init];
        iconView.translatesAutoresizingMaskIntoConstraints = false;
        iconView.image = [UIImage imageNamed:attender.avatar];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.clipsToBounds = true;
        [self.iconBackView addSubview:iconView];
        [attenderArray addObject:iconView];
    }
    self.attenderArray = attenderArray;
    
    UIImageView* anchorView = [[UIImageView alloc] init];
    anchorView.translatesAutoresizingMaskIntoConstraints = false;
    anchorView.image = [UIImage imageNamed:@"anchor"];
    [self addSubview:anchorView];
    self.anchorView = anchorView;
    
    UILabel* locationLabel = [[UILabel alloc] init];
    locationLabel.translatesAutoresizingMaskIntoConstraints = false;
    locationLabel.font = [UIFont systemFontOfSize:12.f];
    locationLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    locationLabel.text = self.eventVM.event.location;
    [self addSubview:locationLabel];
    self.locationLabel = locationLabel;
}

- (void)_addConstraints {
    [self.startLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:5.f].active = true;
    [self.startLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:7.f].active = true;
    [self.startLabel.widthAnchor constraintEqualToConstant:60.f].active = true;
    [self.startLabel.heightAnchor constraintEqualToConstant:25.f].active = true;
    
    [self.rangeLabel.topAnchor constraintEqualToAnchor:self.startLabel.bottomAnchor constant:0.f].active = true;
    [self.rangeLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:7.f].active = true;
    [self.rangeLabel.widthAnchor constraintEqualToConstant:60.f].active = true;
    [self.rangeLabel.heightAnchor constraintEqualToConstant:20.f].active = true;
    
    [self.typeView.leadingAnchor constraintEqualToAnchor:self.startLabel.trailingAnchor constant:10.f].active = true;
    [self.typeView.topAnchor constraintEqualToAnchor:self.topAnchor constant:12.f].active = true;
    [self.typeView.widthAnchor constraintEqualToConstant:10.f].active = true;
    [self.typeView.heightAnchor constraintEqualToConstant:10.f].active = true;
    
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.typeView.trailingAnchor constant:10.f].active = true;
    [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:5.f].active = true;
    [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-7.f].active = true;
    [self.titleLabel.heightAnchor constraintEqualToConstant:25.f].active = true;
    
    [self.iconBackView.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor].active = true;
    [self.iconBackView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:5.f].active = true;
    [self.iconBackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-7.f].active = true;
    [self.iconBackView.heightAnchor constraintEqualToConstant:25.f].active = true;
    
    for (int i = 0; i < [self.attenderArray count]; ++i) {
        UIView* iconView = [self.attenderArray objectAtIndex:i];
        if (i == 0) {
            [iconView.leadingAnchor constraintEqualToAnchor:self.iconBackView.leadingAnchor].active = true;
        }
        else{
            UIView* prev = [self.attenderArray objectAtIndex:i-1];
            [iconView.leadingAnchor constraintEqualToAnchor:prev.trailingAnchor constant:7.f].active = true;
        }
        [iconView.centerYAnchor constraintEqualToAnchor:self.iconBackView.centerYAnchor].active = true;
        [iconView.widthAnchor constraintEqualToConstant:20.f].active = true;
        [iconView.heightAnchor constraintEqualToConstant:20.f].active = true;
        iconView.layer.cornerRadius = 10.f;
    }
    
    [self.anchorView.leadingAnchor constraintLessThanOrEqualToAnchor:self.titleLabel.leadingAnchor constant:-2.f].active = true;
    [self.anchorView.topAnchor constraintEqualToAnchor:self.iconBackView.bottomAnchor constant:5.f].active = true;
    [self.anchorView.widthAnchor constraintEqualToConstant:20.f].active = true;
    [self.anchorView.heightAnchor constraintEqualToConstant:20.f].active = true;
    
    [self.locationLabel.leadingAnchor constraintEqualToAnchor:self.anchorView.trailingAnchor constant:2.f].active = true;
    [self.locationLabel.topAnchor constraintEqualToAnchor:self.anchorView.topAnchor constant:5.f].active = true;
    [self.locationLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-7.f].active = true;
    [self.locationLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-7.f].active = true;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView* iconView in self.attenderArray){
        iconView.layer.cornerRadius = 20.f/2;
    }
    self.typeView.layer.cornerRadius = self.typeView.width/2.f;
}

@end

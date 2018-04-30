//
//  BLNullEventCellView.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/29.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLNullEventCellView.h"

@implementation BLNullEventCellView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.borderWidth = 1.f;
        self.borderColor = [UIColor lightGrayColor];
        
        UILabel* label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:12.f];
        label.text = @"No Event Today";
//        label.backgroundColor = [UIColor yellowColor];
        [self addSubview:label];
        
        [label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:7.f].active = true;
        [label.topAnchor constraintEqualToAnchor:self.topAnchor constant:5.f].active = true;
        [label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-7.f].active = true;
        [label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5.f].active = true;
    }
    return self;
}

@end

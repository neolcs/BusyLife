//
//  BLListSection.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLSectionView.h"
#import "UIView+Common.h"

@interface BLSectionView()

@end

@implementation BLSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.cellArray = [NSMutableArray array];
    }
    return self;
}

- (void)renderCells {
    CGFloat start = 0.f;
    if (self.header) {
        start = self.header.bottom;
    }
    
    for (UIView* cell in self.cellArray){
        cell.top = start;
        start += cell.height;
    }
    self.height = start;
}

- (void)accomodate {
    if (self.top < 0) {
        if (self.height + self.top > self.header.height) {
            self.header.top = -self.top;
        }
        else {
            self.header.bottom = self.height;
        }
    }
    else {
        self.header.top = 0.f;
    }
}

@end

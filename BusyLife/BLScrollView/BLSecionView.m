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

- (void)accomodateInSize:(CGSize)size {
    CGFloat height = size.height;
    
    CGFloat cellHeight = 0.f;
    for (UIView* cell in self.cellArray){
        cellHeight += cell.height;
    }
    CGFloat headerHeight = self.header.height;
    
    if (height > headerHeight) {
        self.header.top = 0.f;
    }
    else {
        self.header.bottom = self.height;
    }
    
    if (height >= headerHeight + cellHeight) {
        CGFloat start = self.header.bottom;
        for (UIView* cell in self.cellArray){
            cell.top = start;
            start += cell.height;
            
        }
        height = headerHeight + cellHeight;
        
        _fullExpanded = true;           // set if fully expanded by side
    }
    else {
        CGFloat bottom = self.height;
        for (NSInteger i = [self.cellArray count] - 1; i >= 0; --i) {
            UIView* cell = [self.cellArray objectAtIndex:i];
            cell.bottom = bottom;
            bottom -= cell.height;
        }
        _fullExpanded = false;          // set if fully expanded by side
    }
    
    self.width = self.width;
    self.height = height;
}

@end

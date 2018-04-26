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

@property (nonatomic, strong) UIView* header;
@property (nonatomic, strong) NSMutableArray* cellArray;

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

- (void)accomodateInSize:(CGSize)size {
    CGFloat width = size.width;
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
    
    width = MAX(self.header.width, width);
    
    if (height >= headerHeight + cellHeight) {
        CGFloat start = self.header.bottom;
        for (UIView* cell in self.cellArray){
            cell.top = start;
            start += cell.height;
            
            width = MAX(cell.width, width);
        }
        height = headerHeight + cellHeight;
    }
    else {
        CGFloat bottom = self.height;
        for (NSInteger i = [self.cellArray count] - 1; i >= 0; --i) {
            UIView* cell = [self.cellArray objectAtIndex:i];
            cell.bottom = bottom;
            bottom -= cell.height;
            
            width = MAX(cell.width, width);
        }
    }
    
    self.width = width;
    self.height = height;
}

- (BOOL)fullExpanded {
    CGFloat cellHeight = 0.f;
    for (UIView* cell in self.cellArray){
        cellHeight += cell.height;
    }
    CGFloat headerHeight = self.header.height;
    
    return self.height >= cellHeight + headerHeight;
}

@end

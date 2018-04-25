//
//  BLNumberCellView.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLNumberCellView.h"
#import "BLNumberInfo.h"

@interface BLNumberCellView()

@property (nonatomic, strong) UILabel* infoLabel;

@end

@implementation BLNumberCellView

@synthesize cellInfo = _cellInfo;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.infoLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.infoLabel];
    }
    return self;
}

- (void)setCellInfo:(BLNumberInfo *)cellInfo{
    _cellInfo = cellInfo;
    self.infoLabel.text = [NSString stringWithFormat:@"%ld", cellInfo.num];
}

@end

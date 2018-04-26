//
//  ViewController.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLViewController.h"
#import "BLScrollView.h"
#import "BLNumberInfo.h"
#import "BLNumberCellView.h"
#import "BLScrollView/BLNumberSectionInfo.h"
#import "UIView+Common.h"

@interface BLViewController ()<BLScrollViewDelegate, BLScrollViewDataSource>

@end

@implementation BLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BLScrollView* scrollView = [[BLScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor cyanColor];
    scrollView.delegate = self;
    scrollView.dataSource = self;
    scrollView.topSectionInfo = [[BLNumberSectionInfo alloc] initWithGroup:0];
    [scrollView reloadData];
    [self.view addSubview:scrollView];
    
}

#pragma mark - BLScrollViewDelegate
- (void)cellWillBeRemoved:(BLCellView *)cell{
}

#pragma mark - BLScrollViewDataSource
- (BLCellView *)scrollView:(BLScrollView *)scrollView cellForInfo:(BLCellInfo *)cellInfo{
    BLNumberCellView* cellView = [[BLNumberCellView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40.f)];
    cellView.cellInfo = cellInfo;
    return cellView;
}

- (UIView *)scrollView:(BLScrollView *)scrollView headerForInfo:(BLNumberSectionInfo *)sectionInfo{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30.f)];
    label.text = [NSString stringWithFormat:@"%d", sectionInfo.groupNum];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor magentaColor];
    return label;
}

@end

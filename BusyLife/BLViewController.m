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
    scrollView.topCellInfo = [[BLNumberInfo alloc] initWithNum:0];
    [scrollView reloadData];
    [self.view addSubview:scrollView];
    
}

#pragma mark - BLScrollViewDelegate
- (void)cellWillBeRemoved:(BLCellView *)cell{
    NSLog(@"cell will be removed...");
}

#pragma mark - BLScrollViewDataSource
- (BLCellView *)cellForInfo:(BLCellInfo *)cellInfo{
    BLNumberCellView* cellView = [[BLNumberCellView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40.f)];
    cellView.cellInfo = cellInfo;
    cellView.backgroundColor = [UIColor orangeColor];
    return cellView;
}
@end

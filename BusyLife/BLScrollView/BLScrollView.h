//
//  BLScrollView.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCellView.h"
#import "BLCellInfo.h"

@protocol BLScrollViewDelegate

- (void)cellWillBeRemoved:(BLCellView *)cell;       //Called when the cell is out of the visible rect, hence is remove from BLScrollView

@end

@protocol BLScrollViewDataSource

- (BLCellView *)cellForInfo:(BLCellInfo *)cellInfo;     //Should return the correspond BLCellView for the cellInfo, this method is required

//TODO
@optional
- (UIView *)headerForInfo:(BLCellInfo *)cellInfo;       //Return the header view for the cell info, optional

@end

@interface BLScrollView : UIView

@property (nonatomic, weak) id<BLScrollViewDelegate> delegate;
@property (nonatomic, weak) id<BLScrollViewDataSource> dataSource;

//Since BLScrollView could scroll up and down infinitely, the indexPath is not valid here, we use the topCellInfo as the anchor for current state
//The topCellInfo must be set, or nothing would show up
@property (nonatomic, strong) BLCellInfo* topCellInfo;

//Similar to UITableView, when topCellInfo is changed or view size change is changed, call this method to reload data
- (void)reloadData;

@end

//
//  BLScrollView.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCellView.h"
#import "BLSectionInfo.h"
#import "BLSectionView.h"

@class BLScrollView;
@protocol BLScrollViewDelegate<NSObject>

- (void)cellWillBeRemoved:(BLCellView *)cell;       //called when the cell is out of the visible rect, hence is remove from BLScrollView

@end

@protocol BLScrollViewDataSource<NSObject>

//implement this method to return a CellView with the info from cellInfo
- (UIView *)scrollView:(BLScrollView *)scrollView cellForInfo:(BLCellInfo *)cellInfo;

@optional
//return the header view for the cell info, optional to implement, if not implement, there would be no header
- (UIView *)scrollView:(BLScrollView *)scrollView headerForInfo:(BLSectionInfo *)cellInfo;

@end

@interface BLScrollView : UIView

@property (nonatomic, weak) id<BLScrollViewDelegate> delegate;
@property (nonatomic, weak) id<BLScrollViewDataSource> dataSource;

//Since BLScrollView could scroll up and down infinitely, the indexPath is not valid here, we use the topCellInfo as the anchor for current state
//The topCellInfo must be set, or nothing would show up
@property (nonatomic, strong) BLSectionInfo* topSectionInfo;

//Similar to UITableView, when topCellInfo is changed or view size change is changed, call this method to reload data
- (void)reloadData;
- (BLSectionView *)sectionViewFor:(BLSectionInfo *)sectionInfo;

@end

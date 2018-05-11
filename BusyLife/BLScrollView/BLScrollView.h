//
//  BLScrollView.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLSectionInfo.h"
#import "BLSectionView.h"

@class BLScrollView;
@protocol BLScrollViewDelegate<NSObject>

@optional
- (void)scrollViewDidStartScroll:(BLScrollView *)scrollView;
- (void)scrollViewDidStopScroll:(BLScrollView *)scrollView;
- (void)scrollView:(BLScrollView *)scrollView sectionWillBeRemoved:(id<BLSectionInfo>)sectionInfo;       //called when the section is out of the visible rect, hence is remove from BLScrollView

//the delegate method called when the top most section changed to another info
- (void)scrollView:(BLScrollView *)scrollView topSectionChanged:(id<BLSectionInfo>)sectionInfo;

@end

@protocol BLScrollViewDataSource<NSObject>

//implement this method to return a CellView with the info from cellInfo
- (UIView *)scrollView:(BLScrollView *)scrollView cellForInfo:(id)cellInfo;
//required to implement. return the height of the cell for cellInfo
- (CGFloat)scrollView:(BLScrollView *)scrollView cellHeightForInfo:(id)cellInfo;

@optional
//return the header view for the cell info, optional to implement, if not implement, there would be no header
- (UIView *)scrollView:(BLScrollView *)scrollView headerForInfo:(id<BLSectionInfo>)sectionInfo;

@end

@interface BLScrollView : UIView

@property (nonatomic, weak) id<BLScrollViewDelegate> delegate;
@property (nonatomic, weak) id<BLScrollViewDataSource> dataSource;

//Since BLScrollView could scroll up and down infinitely, the indexPath is not valid here, we use the topCellInfo as the anchor for current state
//The topCellInfo must be set, or nothing would show up
@property (nonatomic, strong) id<BLSectionInfo> topSectionInfo;

@property (nonatomic, strong) NSMutableArray* sectionViewArray;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, readonly) BOOL scrolling;

//Similar to UITableView, when topCellInfo is changed or view size change is changed, call this method to reload data
- (void)reloadData;
- (BLSectionView *)sectionViewFor:(id<BLSectionInfo>)sectionInfo;
- (id<BLSectionInfo>)currentSection;
- (void)scrollOffset:(CGPoint)offset animated:(BOOL)animated;

@end

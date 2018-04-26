//
//  BLListSection.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "BLCellView.h"
#import "BLSectionInfo.h"

@interface BLSectionView : UIView

@property (nonatomic, strong) BLSectionInfo* sectionInfo;
@property (nonatomic, readonly) BOOL fullExpanded;


//reorganize the cells and header with respect to the size
- (void)accomodateInSize:(CGSize)size;

@end

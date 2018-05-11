//
//  BLListSection.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BLSectionInfo.h"

@interface BLSectionView : UIView

@property (nonatomic, strong) UIView* header;
@property (nonatomic, strong) NSArray* cellArray;
@property (nonatomic, strong) id<BLSectionInfo> sectionInfo;


//reorganize the cells and header with respect to the size
- (void)accomodate;
- (void)renderCells;

@end

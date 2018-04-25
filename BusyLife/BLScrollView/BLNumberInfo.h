//
//  YTNumberInfo.h
//  ScrollInfinite
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLCellInfo.h"

@interface BLNumberInfo : BLCellInfo

@property(nonatomic, assign) NSInteger num;

- (instancetype)initWithNum:(NSInteger)num;

@end

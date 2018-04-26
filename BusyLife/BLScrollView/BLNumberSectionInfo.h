//
//  BLNumberSectionInfo.h
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLSectionInfo.h"

@interface BLNumberSectionInfo : BLSectionInfo

@property (nonatomic, assign) int groupNum;

- (instancetype)initWithGroup:(int)group;

@end

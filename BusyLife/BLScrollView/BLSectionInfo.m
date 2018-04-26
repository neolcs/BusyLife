//
//  BLSectionInfo.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLSectionInfo.h"

@implementation BLSectionInfo

- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellInfoArray = [NSMutableArray array];
    }
    return self;
}

- (BLSectionInfo *)previous{
    NSAssert(false, @"BLSectionInfo previous should be override in subclass");
    return nil;
}

- (BLSectionInfo *)next{
    NSAssert(false, @"BLSectionInfo next should be override in subclass");
    return nil;
}

@end

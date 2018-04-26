//
//  BLCellInfo.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLCellInfo.h"

@implementation BLCellInfo

- (BLCellInfo *)previous{
    NSAssert(false, @"BLCellInfo previous should be override in subclass");
    return nil;
}

- (BLCellInfo *)next{
    NSAssert(false, @"BLCellInfo next should be override in subclass");
    return nil;
}

- (NSString *)sectionKey{
    NSAssert(false, @"BLCellInfo sectionKey should be override in subclass");
    return @"";
}

@end

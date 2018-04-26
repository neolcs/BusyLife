//
//  BLNumberSectionInfo.m
//  BusyLife
//
//  Created by ChuanLi on 2018/4/26.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLNumberSectionInfo.h"
#import "BLNumberInfo.h"

@implementation BLNumberSectionInfo

- (instancetype)initWithGroup:(int)group{
    self = [super init];
    if (self) {
        self.groupNum = group;
        
        self.cellInfoArray = [NSMutableArray array];
        for (int i = 0; i < 5; ++i) {
            BLNumberInfo* cellInfo = [[BLNumberInfo alloc] initWithNum:self.groupNum*10 + i];
            [self.cellInfoArray addObject:cellInfo];
        }
    }
    return self;
}

- (BLNumberSectionInfo *)previous{
    return [[BLNumberSectionInfo alloc] initWithGroup:self.groupNum - 1];
}

- (BLNumberSectionInfo *)next{
    return [[BLNumberSectionInfo alloc] initWithGroup:self.groupNum + 1];
}

- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:NSClassFromString(@"BLNumberSectionInfo")]) {
        return NO;
    }
    BLNumberSectionInfo* another = (BLNumberSectionInfo *)object;
    return self.groupNum == another.groupNum;
}

@end

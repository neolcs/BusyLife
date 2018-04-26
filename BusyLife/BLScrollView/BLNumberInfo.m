//
//  YTNumberInfo.m
//  ScrollInfinite
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLNumberInfo.h"

@implementation BLNumberInfo

- (instancetype)initWithNum:(NSInteger)num{
    self = [super init];
    if (self) {
        self.num = num;
    }
    return self;
}

- (BLNumberInfo *)previous{
    return [[BLNumberInfo alloc] initWithNum:self.num - 1];
}

- (BLNumberInfo *)next{
    return [[BLNumberInfo alloc] initWithNum:self.num + 1];
}

- (NSString *)sectionKey{
    NSString* value = [NSString stringWithFormat:@"%ld", self.num / 10];
    return value;
}

@end

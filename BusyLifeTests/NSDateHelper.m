//
//  NSDateHelper.m
//  BusyLifeTests
//
//  Created by ChuanLi on 2018/4/28.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+Helper.h"

@interface NSDateHelper : XCTestCase

@end

@implementation NSDateHelper

- (void)testResetDate {
    NSDate* date51 = [NSDate dateWithTimeIntervalSince1970:1525190399];   //2018-05-01 23:59:59
    NSDate* date52 = [NSDate dateWithTimeIntervalSince1970:1525190401];   //2018-05-02 00:00:01
    NSDate* standardDate = [NSDate dateWithTimeIntervalSince1970:1525104000]; //2018-05-01 00:00:00
    NSDate* resetDate51 = [date51 resetTo0];
    NSDate* resetDate52 = [date52 resetTo0];
    XCTAssert([resetDate51 isEqual:standardDate], @"reset to start of day, not work correctlly");
    XCTAssert(![resetDate52 isEqual:standardDate], @"reset to start of day, not work correctlly");
}

@end

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

- (void)testIsSameDay {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* feb2 = [formatter dateFromString:@"2016-02-02 01:01:01"];
    NSDate* feb2_ = [formatter dateFromString:@"2016-02-02 23:23:23"];
    XCTAssert([feb2 isSameDayWith:feb2_], @"feb 2 sameday check failed");
    NSDate* feb1 = [formatter dateFromString:@"2016-02-01 23:59:59"];
    XCTAssert(![feb2 isSameDayWith:feb1], @"Feb 1st is not same day as Feb 2nd");
}

- (void)testDayTime{
    NSDate* pmDate = [NSDate dateWithTimeIntervalSince1970:1525190399];
    NSString* dayTime = [pmDate dayTime];
    XCTAssert([dayTime isEqualToString:@"11:59 PM"], @"day time for pm error");
    
    NSDate* amDate = [NSDate dateWithTimeIntervalSince1970:1525133100];
    dayTime = [amDate dayTime];
    XCTAssert([dayTime isEqualToString:@"8:05 AM"], @"day time for am error");
}

- (void)testHeaderDisplay {
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:1525133100];
    NSString* headerDisplay = [date headerDisplay];
    XCTAssert([headerDisplay isEqualToString:@"TUESDAY, MAY 1"], @"header display error");
}

@end

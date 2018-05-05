//
//  BLEventViewModelTests.m
//  BusyLifeTests
//
//  Created by ChuanLi on 2018/5/5.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLEvent.h"
#import "BLEventViewModel.h"

@interface BLEventViewModelTests : XCTestCase

@end

@implementation BLEventViewModelTests

- (void)testStartTime{
    BLEvent* event = [[BLEvent alloc] init];
    event.startDate = [NSDate dateWithTimeIntervalSince1970:1449885900];
    BLEventViewModel* eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.startTime isEqualToString:@"10:05 AM"], @"start time for '10:05 AM' render error");
    
    event.startDate = [NSDate dateWithTimeIntervalSince1970:1449892800];
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.startTime isEqualToString:@"12:00 PM"], @"startTime for '12:00 PM' render error");
    
    event.startDate = [NSDate dateWithTimeIntervalSince1970:1449935999];
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.startTime isEqualToString:@"11:59 PM"], @"startTime for '11:59 PM' render error");
    
    event.startDate = [NSDate dateWithTimeIntervalSince1970:1449936000];
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.startTime isEqualToString:@"12:00 AM"], @"startTime for '12:00 AM' render error");
}

- (void)testRange{
    BLEvent* event = [[BLEvent alloc] init];
    event.range = 24*60*60;
    BLEventViewModel* eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.range isEqualToString:@"24h"], @"range for 24h render error");
    
    event.range = 6*60*60 + 38*60 + 30;
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.range isEqualToString:@"6h 38m"], @"range for 6h 38m 30s render error");
    
    event.range = 59*60 + 59;
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.range isEqualToString:@"59m"], @"range for 59m 59s render error");
    
    event.range = 59;
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.range isEqualToString:@"1m-"], @"range for less than 1m render error");
    
    event.range = 25*60*60;
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.range isEqualToString:@"24h+"], @"range for over than 24h render error");
}

- (void)testTypeColor{
    BLEvent* event = [[BLEvent alloc] init];
    event.type = 1;
    BLEventViewModel* eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.typeColor isEqual:[UIColor yellowColor]], @"typeColor for 1 render error");
    
    event.type = 2;
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.typeColor isEqual:[UIColor redColor]], @"typeColor for 2 render error");
    
    event.type = 3;
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.typeColor isEqual:[UIColor greenColor]], @"typeColor for 3 render error");
    
    event.type = 100;
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.typeColor isEqual:[UIColor magentaColor]], @"typeColor for others render error");
}

- (void)testLocation {
    BLEvent* event = [[BLEvent alloc] init];
    BLEventViewModel* eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssertNil(eventVM.location, @"location should be nil if not set");
    
    BLLocation* location = [[BLLocation alloc] init];
    location.city = @"Suzhou";
    location.name = nil;
    event.location = location;
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.location isEqual:@"Suzhou"], @"location should be just city if address not set");
    
    location.city = nil;
    location.name = @"Sit&Forget Study";
    event.location = location;
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.location isEqualToString:@"Sit&Forget Study"], @"location should be just address if city not set");
    
    location.name = @"Sit&Forget Study";
    location.city = @"Suzhou";
    event.location = location;
    eventVM = [[BLEventViewModel alloc] initWithEvent:event];
    XCTAssert([eventVM.location isEqualToString:@"Suzhou, Sit&Forget Study"], @"location should has city and address");
}

@end

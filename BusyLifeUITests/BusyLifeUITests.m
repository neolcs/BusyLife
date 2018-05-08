//
//  BusyLifeUITests.m
//  BusyLifeUITests
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BusyLifeUITests : XCTestCase

@end

@implementation BusyLifeUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSwipe {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *calendarView = app.otherElements[@"calendarView"];
    [calendarView swipeUp];
    
    NSUInteger calendarViewSectionNumber = [[[calendarView childrenMatchingType:XCUIElementTypeAny] matchingIdentifier:@"sectionView"] count];
    XCTAssert( calendarViewSectionNumber >= 6 && calendarViewSectionNumber <= 7 , @"when expanding, sections in calendar view is not fully expanded");
    
    XCUIElement* agendarView = app.otherElements[@"agendaView"];
    [agendarView swipeUp];
    
    calendarViewSectionNumber = [[[calendarView childrenMatchingType:XCUIElementTypeAny] matchingIdentifier:@"sectionView"] count];
    XCTAssert( calendarViewSectionNumber >= 2 && calendarViewSectionNumber <= 3 , @"when folding, sections in calendar view is not correctly folded up");
}

@end

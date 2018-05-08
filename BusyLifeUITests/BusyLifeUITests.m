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
    
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
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

- (void)testHighlightChange {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement* highlightDayGrid = app.otherElements[@"DG Highlight"];
    XCTAssert([highlightDayGrid exists], @"cannot find current highlight date");
    NSUInteger unHighlightCount = [[app.otherElements matchingIdentifier:@"DG UnHighlight"] count];
    XCTAssert(unHighlightCount > 0, @"cannot find unhighlight date");
    
    NSUInteger randomIndex = arc4random_uniform((uint32_t) unHighlightCount);
    XCUIElement* unHighlightDayGrid = [[app.otherElements matchingIdentifier:@"DG UnHighlight"] elementBoundByIndex:randomIndex];
    NSString* tapGridValue = unHighlightDayGrid.value;
    
    [unHighlightDayGrid tap];
    
    XCTAssert([highlightDayGrid.value isEqualToString:tapGridValue], @"highlight daygrid not changed correctlly");
}

@end

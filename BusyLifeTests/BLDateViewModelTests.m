//
//  BLDateViewModelTests.m
//  BusyLifeTests
//
//  Created by ChuanLi on 2018/5/3.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLDateViewModel.h"

@interface BLDateViewModelTests : XCTestCase

@end

@implementation BLDateViewModelTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFeb1st {
    BLDateViewModel* dateVM = [[BLDateViewModel alloc] initWithDate:[NSDate dateWithTimeIntervalSince1970:1517443500]];
    
    XCTAssert([dateVM.title isEqualToString:@"Feb\n1"], @"Feb 1st title should be Feb\n1 when highlight is false");
    XCTAssert(dateVM.lineNumber == 2, @"Feb 1st lineNumber should be 2 when highlight is false");
    XCTAssert([dateVM.backColor isEqual:[UIColor whiteColor]], @"Feb 1st cell backColor should be white");
    XCTAssert([dateVM.dayBackColor isEqual:[UIColor clearColor]], @"Feb 1st dayBackColor should be clear when highlight is false");
    XCTAssert([dateVM.dayTextColor isEqual:[UIColor darkGrayColor]], @"Feb 1st dayTextColor should be darkGrayColor when highlight is false");
    
    dateVM.highlight = true;
    
    XCTAssert([dateVM.title isEqualToString:@"1"], @"Feb 1st title should be 1 when highlight is true");
    XCTAssert(dateVM.lineNumber == 1, @"Feb 1st lineNumber should be 1 when highlight is true");
    XCTAssert([dateVM.backColor isEqual:[UIColor whiteColor]], @"Feb 1st cell backColor should be white when highlight is true");
    XCTAssert([dateVM.dayBackColor isEqual:[UIColor blueColor] ], @"Feb 1st dayBackColor should be blue when highlight is true");
    XCTAssert([dateVM.dayTextColor isEqual:[UIColor whiteColor]], @"Feb 1st dayTextColor should be white when highlight is true");
}

@end

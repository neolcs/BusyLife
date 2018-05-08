//
//  BLParserTests.m
//  BusyLifeTests
//
//  Created by ChuanLi on 2018/4/28.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLParser.h"
#import "BLEvent.h"
#import "BLAttender.h"

@interface BLParserTests : XCTestCase

@property (nonatomic, strong) BLParser* parser;
@property (nonatomic, strong) NSArray* eventArray;

@end

@implementation BLParserTests

- (void)setUp {
    [super setUp];
    
    self.parser = [[BLParser alloc] init];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"json"];
    NSData* jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError* err;
    self.eventArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&err];
    if (err) {
        NSLog(@"serialize json failed...");
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParser {
    NSDictionary* dict = [self.eventArray lastObject];
    BLEvent* event = [self.parser parseDict:dict toClass:NSClassFromString(@"BLEvent")];
    XCTAssert(event != nil, @"BLParser could not parse json");
    XCTAssert(event.startDate != nil, @"BLParser could not parse json");
    XCTAssert(event.attends != nil, @"BLParser could not parse json");
}

@end

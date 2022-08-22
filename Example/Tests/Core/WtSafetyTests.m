//
//  WtSafetyTests.m
//  WtCore_Tests
//
//  Created by wtfan on 2022/8/22.
//  Copyright © 2022 JaonFanwt. All rights reserved.
//

#import <XCTest/XCTest.h>

@import WtCore;


@interface WtSafetyTests : XCTestCase

@end

@implementation WtSafetyTests

- (void)setUp {
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testNull {
  id obj = [NSNull null];
  XCTAssertTrue([obj length] == 0);
  XCTAssertFalse([obj isEqualToString:@""]);
  XCTAssertFalse([obj tableView:[UITableView new] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]);
}

@end

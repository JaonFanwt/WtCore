//
//  WtKVOTests.m
//  WtCore_Tests
//
//  Created by wtfan on 2018/8/20.
//  Copyright © 2018年 JaonFanwt. All rights reserved.
//

@import XCTest;

@import WtCore;


@interface WtKVOTests : XCTestCase

@end


@implementation WtKVOTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testKVOValueChanged1 {
  UIView *view = [[UIView alloc] init];
  __block int changedTimes = 0;
  [view wtObserveValueForKeyPath:@keypath(view, hidden) valueChangedBlock:^(id newValue) {
    changedTimes++;
  }];
  view.hidden = NO;
  XCTAssertTrue(changedTimes == 1);
  view.hidden = YES;
  XCTAssertTrue(changedTimes == 2);
  view.hidden = YES;
  XCTAssertTrue(changedTimes == 3);
}

- (void)testKVOValueChanged2 {
  UIView *view = [[UIView alloc] init];
  __block int changedTimes1 = 0;
  __block int num = 0;
  [view wtObserveValueForKeyPath:@keypath(view, hidden) valueChangedBlock:^(id newValue) {
    changedTimes1++;
  }];
  [view wtObserveValueForKeyPath:@keypath(view, hidden) valueChangedBlock:^(id newValue) {
    num++;
    num++;
  }];
  view.hidden = NO;
  XCTAssertTrue(changedTimes1 == 1);
  XCTAssertTrue(num == 2);
  view.hidden = YES;
  XCTAssertTrue(changedTimes1 == 2);
  XCTAssertTrue(num == 4);
  view.hidden = YES;
  XCTAssertTrue(changedTimes1 == 3);
  XCTAssertTrue(num == 6);
}

- (void)testKVOValueChanged3 {
  UIView *view = [[UIView alloc] init];
  __block int changedTimes1 = 0;
  __block int num = 0;
  [view wtObserveValueForKeyPath:@keypath(view, hidden) valueChangedBlock:^(id newValue) {
    changedTimes1++;
  }];
  [view wtObserveValueForKeyPath:@keypath(view, alpha) valueChangedBlock:^(id newValue) {
    num++;
  }];
  view.hidden = NO;
  XCTAssertTrue(changedTimes1 == 1);
  view.hidden = YES;
  XCTAssertTrue(changedTimes1 == 2);
  view.hidden = YES;
  XCTAssertTrue(changedTimes1 == 3);

  view.alpha = 0.1;
  XCTAssertTrue(num == 1);
  view.alpha = 0.2;
  XCTAssertTrue(num == 2);
  view.alpha = 0.3;
  XCTAssertTrue(num == 3);
  view.alpha = 0.4;
  XCTAssertTrue(num == 4);
}

@end

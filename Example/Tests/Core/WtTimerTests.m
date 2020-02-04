//
// WtTimerTests.m
// WtCore_Tests
//
// Created by wtfan on 2020/2/4.
// Copyright © 2020 wtfan.
// 
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//
// no-arc

@import XCTest;

@import WtCore;


@protocol _WtTimerProtocol <NSObject>
- (void)wtTimer:(NSTimer *)timer;
@end

@interface WtTimerTests : XCTestCase

@end

@implementation WtTimerTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testAutoInvalidate {
  __block int counter = 0;
  NSObject *obj = [NSObject new];
  NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    counter++;
  }];
  NSLog(@"Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)timer));
  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
  NSLog(@"Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)timer));
  XCTAssertTrue(timer.isValid);
  [timer wtAutoInvalidateWhenOwnerDealloc:obj];
  [obj release];
  XCTAssertFalse(timer.isValid);
  timer = nil;
  XCTAssertTrue(counter == 0);
}

- (void)testAutoInvalidateAfter3Sec {
  __block int counter = 0;
  __block NSObject *obj = [NSObject new];
  NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    counter++;
  }];
  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
  XCTAssertTrue(timer.isValid);
  [timer wtAutoInvalidateWhenOwnerDealloc:obj];
  XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
  double tolerance = 0.1;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((3.0f + tolerance) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [obj release];
    XCTAssertFalse(timer.isValid);
    [expectation fulfill];
  });
  [self waitForExpectationsWithTimeout:4.0 handler:^(NSError * _Nullable error) {
    XCTAssertTrue(counter == 3);
  }];
}

- (void)testTimerWithTimeInterval {
  WtDelegateProxy<_WtTimerProtocol> *proxy = (WtDelegateProxy<_WtTimerProtocol> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(_WtTimerProtocol)];
  [proxy selector:@selector(wtTimer:) block:^(NSTimer *timer) {

  }];
  NSTimer *timer = [NSTimer wtTimerWithTimeInterval:1.0 target:proxy selector:@selector(wtTimer:) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
  XCTAssertTrue(timer.isValid);
  [proxy release];
  XCTAssertFalse(timer.isValid);
  timer = nil;
}

- (void)testTimerWithTimeIntervalAfter3Sec {
  __block int counter = 0;
  __block WtDelegateProxy<_WtTimerProtocol> *proxy = (WtDelegateProxy<_WtTimerProtocol> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(_WtTimerProtocol)];
  [proxy selector:@selector(wtTimer:) block:^(NSTimer *timer) {
    counter++;
  }];
  NSTimer *timer = [NSTimer wtTimerWithTimeInterval:1.0 target:proxy selector:@selector(wtTimer:) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
  XCTAssertTrue(timer.isValid);
  XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
  double tolerance = 0.1;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((3.0f + tolerance) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [proxy release];
    XCTAssertFalse(timer.isValid);
    [expectation fulfill];
  });
  [self waitForExpectationsWithTimeout:4.0 handler:^(NSError * _Nullable error) {
    XCTAssertTrue(counter == 3);
  }];
  XCTAssertFalse(timer.isValid);
}

- (void)testScheduledTimerWithTimeInterval {
  WtDelegateProxy<_WtTimerProtocol> *proxy = (WtDelegateProxy<_WtTimerProtocol> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(_WtTimerProtocol)];
  [proxy selector:@selector(wtTimer:) block:^(NSTimer *timer) {

  }];
  NSTimer *timer = [NSTimer wtScheduledTimerWithTimeInterval:1.0 target:proxy selector:@selector(wtTimer:) userInfo:nil repeats:YES];
  XCTAssertTrue(timer.isValid);
  [proxy release];
  XCTAssertFalse(timer.isValid);
  timer = nil;
}

- (void)testScheduledTimerWithTimeIntervalAfter3Sec {
  __block int counter = 0;
  __block WtDelegateProxy<_WtTimerProtocol> *proxy = (WtDelegateProxy<_WtTimerProtocol> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(_WtTimerProtocol)];
  [proxy selector:@selector(wtTimer:) block:^(NSTimer *timer) {
    counter++;
  }];
  NSTimer *timer = [NSTimer wtScheduledTimerWithTimeInterval:1.0 target:proxy selector:@selector(wtTimer:) userInfo:nil repeats:YES];
  XCTAssertTrue(timer.isValid);
  XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
  double tolerance = 0.1;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((3.0f + tolerance) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [proxy release];
    XCTAssertFalse(timer.isValid);
    [expectation fulfill];
  });
  [self waitForExpectationsWithTimeout:4.0 handler:^(NSError * _Nullable error) {
    XCTAssertTrue(counter == 3);
  }];
  XCTAssertFalse(timer.isValid);
}

@end

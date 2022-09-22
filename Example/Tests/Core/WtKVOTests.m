//
//  WtKVOTests.m
//  WtCore_Tests
//
//  Created by wtfan on 2018/8/20.
//  Copyright © 2018年 JaonFanwt. All rights reserved.
//

@import XCTest;

@import WtCore;
@import ReactiveObjC;


@interface WtKVOTests : XCTestCase
@property (nonatomic, strong) NSMutableArray *array;
@end


@implementation WtKVOTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  
  self.array = @[].mutableCopy;
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
  
  [self.array removeAllObjects];
  self.array = nil;
}

- (void)testKVOValueNil {
  UILabel *label = [[UILabel alloc] init];
  [label wtObserveValueForKeyPath:@keypath(label, text) valueChangedBlock:^(id  _Nullable newValue) {
    XCTAssertTrue([newValue isKindOfClass:NSNull.class]);
  }];
  label.text = nil;
}

- (void)testKVOValueChanged1 {
  UIView *view = [[UIView alloc] init];
  __block int changedTimes = 0;
  [view wtObserveValueForKeyPath:@keypath(view, hidden) valueChangedBlock:^(id newValue) {
    XCTAssertTrue([newValue isKindOfClass:[NSNumber class]]);
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
    XCTAssertTrue([newValue isKindOfClass:[NSNumber class]]);
    changedTimes1++;
  }];
  [view wtObserveValueForKeyPath:@keypath(view, hidden) valueChangedBlock:^(id newValue) {
    XCTAssertTrue([newValue isKindOfClass:[NSNumber class]]);
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
    XCTAssertTrue([newValue isKindOfClass:[NSNumber class]]);
    changedTimes1++;
  }];
  [view wtObserveValueForKeyPath:@keypath(view, alpha) valueChangedBlock:^(id newValue) {
    XCTAssertTrue([newValue isKindOfClass:[NSNumber class]]);
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

- (void)testKVOValueChanged4 {
  UIView *view = [[UIView alloc] init];
  __block int changedTimes1 = 0;
  for (int i = 0; i < 10000; i++) {
    [view wtObserveValueForKeyPath:@keypath(view, hidden) valueChangedBlock:^(id newValue) {
      XCTAssertTrue([newValue isKindOfClass:[NSNumber class]]);
      changedTimes1++;
    } takeUntilTargetDealloc:view replace:YES];
  }
  view.hidden = NO;
  XCTAssertTrue(changedTimes1 == 1);
  view.hidden = YES;
  XCTAssertTrue(changedTimes1 == 2);
  view.hidden = YES;
  XCTAssertTrue(changedTimes1 == 3);
}

- (void)testKVOPerformance {
  @weakify(self);
  if (@available(iOS 13.0, *)) {
    XCTMeasureOptions *ops = [XCTMeasureOptions new];
    ops.invocationOptions = XCTMeasurementInvocationManuallyStart | XCTMeasurementInvocationManuallyStop;
    [self measureWithMetrics:@[
      XCTClockMetric.new,
//      XCTMemoryMetric.new,
    ] options:ops block:^{
      @strongify(self);
      self.array = @[].mutableCopy;
      
      [self startMeasuring];
      @autoreleasepool {
        NSObject *disposeBag = [[NSObject alloc] init];
        [self.array addObject:disposeBag];
        for (int i = 0; i < 10000; i++) {
          UIView *view = [[UIView alloc] init];
          [self.array addObject:view];
          
          [view wtObserveValueForKeyPath:@keypath(view, frame)
                       valueChangedBlock:^(id  _Nullable newValue) {
            NSLog(@"new frame: %@", newValue);
          } takeUntilTargetDealloc:disposeBag];
        }
      }
      [self stopMeasuring];
      
      [self.array removeAllObjects];
      self.array = nil;
    }];
  } else {
    // Fallback on earlier versions
  }
}

- (void)testRACObserverPerformance {
  @weakify(self);
  if (@available(iOS 13.0, *)) {
    XCTMeasureOptions *ops = [XCTMeasureOptions new];
    ops.invocationOptions = XCTMeasurementInvocationManuallyStart | XCTMeasurementInvocationManuallyStop;
    [self measureWithMetrics:@[
//      XCTClockMetric.new,
      XCTMemoryMetric.new,
    ] options:ops block:^{
      self.array = @[].mutableCopy;
      
      [self startMeasuring];
      @strongify(self);
      @autoreleasepool {
        NSObject *disposeBag = [[NSObject alloc] init];
        [self.array addObject:disposeBag];
        for (int i = 0; i < 10000; i++) {
          UIView *view = [[UIView alloc] init];
          [self.array addObject:view];
          
          [[[RACObserve(view, frame) takeUntil:disposeBag.rac_willDeallocSignal] skip:1] subscribeNext:^(id  _Nullable x) {
            NSLog(@"new frame: %@", x);
          }];
        }
      }
      [self stopMeasuring];
      
      [self.array removeAllObjects];
      self.array = nil;
    }];
  } else {
    // Fallback on earlier versions
  }
}

@end

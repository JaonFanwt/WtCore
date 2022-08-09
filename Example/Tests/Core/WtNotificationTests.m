//
//  WtNotificationTests.m
//  WtCore_Tests
//
//  Created by wtfan on 2022/8/9.
//  Copyright © 2022 JaonFanwt. All rights reserved.
//

@import XCTest;

@import WtCore;


@interface WtNotificationTests : XCTestCase

@end

@implementation WtNotificationTests

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

- (void)testNotification {
  static NSString *kWtTestNotificationName = @"kWtTestNotificationName";
  NSObject *target = [[NSObject alloc] init];
  __block int counter = 0;
  
  [NSNotificationCenter.defaultCenter wtAddObserverForName:kWtTestNotificationName
                                                    object:nil
                                                     queue:NSOperationQueue.mainQueue
                                                     block:^(NSNotification * _Nullable notification, id _Nullable observer) {
    counter++;
  } takeUntilTargetDealloc:target];
  
  for (int i = 0; i < 100; i++) {
    [NSNotificationCenter.defaultCenter postNotificationName:kWtTestNotificationName object:nil];
  }

  XCTAssertTrue(counter == 100);
  
  [target release];
  
  for (int i = 0; i < 100; i++) {
    [NSNotificationCenter.defaultCenter postNotificationName:kWtTestNotificationName object:nil];
  }
  
  XCTAssertTrue(counter == 100);
}

- (void)testSelfRemoveObserver {
  static NSString *kWtTestNotificationName = @"kWtTestNotificationName";
  NSObject *target = [[NSObject alloc] init];
  __block int counter = 0;
  
  [NSNotificationCenter.defaultCenter wtAddObserverForName:kWtTestNotificationName
                                                    object:nil
                                                     queue:NSOperationQueue.mainQueue
                                                     block:^(NSNotification * _Nullable notification, id _Nullable observer) {
    counter++;
    [NSNotificationCenter.defaultCenter removeObserver:observer];
  } takeUntilTargetDealloc:target];
  
  for (int i = 0; i < 100; i++) {
    [NSNotificationCenter.defaultCenter postNotificationName:kWtTestNotificationName object:nil];
  }
  
  XCTAssertTrue(counter == 1);
  
  [target release];
  
  for (int i = 0; i < 100; i++) {
    [NSNotificationCenter.defaultCenter postNotificationName:kWtTestNotificationName object:nil];
  }
  
  XCTAssertTrue(counter == 1);
}

@end

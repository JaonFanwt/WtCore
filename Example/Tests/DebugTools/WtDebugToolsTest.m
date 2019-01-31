//
//  WtDebugToolsTest.m
//  WtCore_Tests
//
//  Created by fan weitian on 2019/1/31.
//  Copyright © 2019 JaonFanwt. All rights reserved.
//

@import XCTest;

@import WtCore;


@interface WtDebugToolsTest : XCTestCase

@end

@implementation WtDebugToolsTest
- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  
  [WtDebugSwitchNetworkManager sharedManager].initialNetworkGroupsIfNecessary = ^NSArray<WtDebugSwitchNetworkGroup *> * {
    NSMutableArray *result = @[].mutableCopy;
    
    { //登录接口
      WtDebugSwitchNetworkGroup *group = [[WtDebugSwitchNetworkGroup alloc] init];
      group.key = @"Atom";
      group.name = @"数据接口";
      [result addObject:group];
      
      WtDebugSwitchNetworkItem *model = [[WtDebugSwitchNetworkItem alloc] init];
      model.urlString = @"测试环境";
      model.urlDescription = @"";
      
      WtDebugSwitchNetworkItem *model2 = [[WtDebugSwitchNetworkItem alloc] init];
      model2.urlString = @"正式环境";
      model2.urlDescription = @"";
      
      [group addModel:model];
      [group addModel:model2];
      
      [group selectModel:model];
    }
    
    return result;
  };
  [[WtDebugSwitchNetworkManager sharedManager] networkGroups];
  [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
  
  [WtDebugSwitchNetworkDB cleanCache:nil];
}

- (void)testCleanCache {
  NSArray *caches = [WtDebugSwitchNetworkDB loadFromCache];
  XCTAssertNotNil(caches);
  XCTAssertTrue(caches.count == 1);
  BOOL success = [WtDebugSwitchNetworkDB cleanCache:nil];
  XCTAssertTrue(success);
  caches = [WtDebugSwitchNetworkDB loadFromCache];
  XCTAssertTrue(caches.count == 0);
}
@end

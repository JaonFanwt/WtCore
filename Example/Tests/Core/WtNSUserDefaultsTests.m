//
//  WtNSUserDefaultsTests.m
//  WtCore_Tests
//
//  Created by wtfan on 2018/8/19.
//  Copyright © 2018年 JaonFanwt. All rights reserved.
//

@import XCTest;

@import WtCore;


@interface WtNSUserDefaultsTests : XCTestCase

@end


@implementation WtNSUserDefaultsTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testBOOL {
  [NSUserDefaults wtSaveValue:@YES key:@"NSUserDefaults-WtExtension-BOOL-YES"];
  id objYes = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-BOOL-YES"];
  XCTAssertNotNil(objYes);
  XCTAssertTrue([objYes boolValue]);

  [NSUserDefaults wtSaveValue:@NO key:@"NSUserDefaults-WtExtension-BOOL-NO"];
  id objNo = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-BOOL-NO"];
  XCTAssertNotNil(objNo);
  XCTAssertFalse([objNo boolValue]);
}

- (void)testChar {
  [NSUserDefaults wtSaveValue:@'A' key:@"NSUserDefaults-WtExtension-Char-A"];
  id objChar_A = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-Char-A"];
  XCTAssertNotNil(objChar_A);
  XCTAssertTrue([objChar_A charValue] == 'A');

  [NSUserDefaults wtSaveValue:@'a' key:@"NSUserDefaults-WtExtension-Char-a"];
  id objChar_a = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-BOOL-NO"];
  XCTAssertNotNil(objChar_a);
  XCTAssertFalse([objChar_a charValue] == 'a');
}

- (void)testInt {
  [NSUserDefaults wtSaveValue:@0 key:@"NSUserDefaults-WtExtension-int-0"];
  id objInt0 = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-int-0"];
  XCTAssertNotNil(objInt0);
  XCTAssertTrue([objInt0 intValue] == 0);

  [NSUserDefaults wtSaveValue:@NO key:@"NSUserDefaults-WtExtension-int-1"];
  id objInt1 = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-int-1"];
  XCTAssertNotNil(objInt1);
  XCTAssertFalse([objInt0 intValue] == 1);

  [NSUserDefaults wtSaveValue:@NO key:@"NSUserDefaults-WtExtension-int-(-1)"];
  id objIntNegative1 = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-int-(-1)"];
  XCTAssertNotNil(objIntNegative1);
  XCTAssertFalse([objIntNegative1 intValue] == -1);
}

- (void)testDouble {
  [NSUserDefaults wtSaveValue:@3.1415926 key:@"NSUserDefaults-WtExtension-double-pi"];
  id objDoublePi = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-double-pi"];
  XCTAssertNotNil(objDoublePi);
  XCTAssertTrue([objDoublePi doubleValue] - 3.1415926 < 0.0000001);
}

- (void)testString {
  [NSUserDefaults wtSaveValue:@"The ObjC is the best language in the world." key:@"NSUserDefaults-WtExtension-string"];
  id objString = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-string"];
  XCTAssertNotNil(objString);
  XCTAssertTrue([objString isEqualToString:@"The ObjC is the best language in the world."]);
}

- (void)testDate {
  NSDate *date = [NSDate date];
  [NSUserDefaults wtSaveValue:date key:@"NSUserDefaults-WtExtension-date"];
  NSDate *objDate = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-date"];
  XCTAssertNotNil(objDate);
  XCTAssertTrue([objDate timeIntervalSince1970] - [date timeIntervalSince1970] < 0.0001);
}

- (void)testArray {
  [NSUserDefaults wtSaveValue:@[ @0, @1, @2 ] key:@"NSUserDefaults-WtExtension-Array"];
  NSArray *obj = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-Array"];
  XCTAssertNotNil(obj);
  XCTAssertTrue([obj isKindOfClass:[NSArray class]]);
  XCTAssertTrue(obj.count == 3);
  XCTAssertTrue([obj[0] intValue] == 0);
  XCTAssertTrue([obj[1] intValue] == 1);
  XCTAssertTrue([obj[2] intValue] == 2);
}

- (void)testDictionary {
  [NSUserDefaults wtSaveValue:@{ @"name" : @"wtCore",
                                 @"age" : @18 }
                          key:@"NSUserDefaults-WtExtension-Array"];
  NSDictionary *obj = [NSUserDefaults wtGetValueWithKey:@"NSUserDefaults-WtExtension-Array"];
  XCTAssertNotNil(obj);
  XCTAssertTrue([obj isKindOfClass:[NSDictionary class]]);
  XCTAssertNotNil(obj[@"name"]);
  XCTAssertNotNil(obj[@"age"]);
  XCTAssertTrue([obj[@"name"] isEqualToString:@"wtCore"]);
  XCTAssertTrue([obj[@"age"] intValue] == 18);
}

@end

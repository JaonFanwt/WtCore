//
//  WtUIViewTests.m
//  WtCore_Tests
//
//  Created by fan weitian on 2018/8/20.
//  Copyright © 2018 JaonFanwt. All rights reserved.
//

@import XCTest;

@import WtCore;


@interface WtUIViewTests : XCTestCase

@end

@implementation WtUIViewTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testFirstSubViewWithClass {
  UIView *containerView = [[UIView alloc] init];
  UILabel *label = [[UILabel alloc] init]; [containerView addSubview:label];
  UIView *subview = [[UIView alloc] init]; [containerView addSubview:subview];
  UIScrollView *scrollView = [[UIScrollView alloc] init]; [subview addSubview:scrollView];
  UITextView *textView = [[UITextView alloc] init]; [scrollView addSubview:textView];
  
  UIScrollView *foundScrollView = (UIScrollView *)[containerView wtFirstSubViewWithClass:[UIScrollView class]];
  UITextView *foundTextView = (UITextView *)[containerView wtFirstSubViewWithClass:[UITextView class]];
  
  XCTAssertTrue(foundScrollView == scrollView);
  XCTAssertTrue(foundTextView == textView);
}

@end

//
// NSURL+WtExtension.m
// WtCore_Tests
//
// Created by wtfan on 2020/2/13.
// Copyright © 2020 wtfan.
// 
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
// 

@import XCTest;

@import WtCore;


@interface NSURL_WtExtension : XCTestCase
@property (nonatomic, strong) NSURL *url;
@end

@implementation NSURL_WtExtension

- (void)setUp {
  // Put setup code here. This method is called before the invocation of each test method in the class.
  NSString *baseUrlString = @"https://www.wtfan.com:111111";
  NSString *urlString = @"NSURL/test?param1=1&param2=abc&param3=中文&param1=3&param3=english";
  NSURL *baseUrl = [NSURL URLWithString:baseUrlString];
  NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] relativeToURL:baseUrl];
  self.url = url;
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testQueryComponents {
  NSURL *url = self.url;
  
  NSDictionary<NSString *, NSArray<NSString *> *> *queries = [url wtQueryComponents];
  BOOL b = [queries[@"param1"] isEqualToArray:@[@"1", @"3"]];
  XCTAssertTrue(b);
  b = [queries[@"param2"] isEqualToArray:@[@"abc"]];
  XCTAssertTrue(b);
  b = [queries[@"param3"] isEqualToArray:@[@"中文", @"english"]];
  XCTAssertTrue(b);
}

- (void)testQueryComponentsWithNoDuplicate {
  NSURL *url = self.url;
  
  NSDictionary<NSString *, NSString *> *queries = [url wtQueryComponentsWithNoDuplicate];
  BOOL b = [queries[@"param1"] isEqualToString:@"1"];
  XCTAssertTrue(b);
  b = [queries[@"param2"] isEqualToString:@"abc"];
  XCTAssertTrue(b);
  b = [queries[@"param3"] isEqualToString:@"中文"];
  XCTAssertTrue(b);
}

- (void)testQueryComponentNamed {
  NSURL *url = self.url;
  
  XCTAssertTrue([@"1" isEqualToString:[url wtQueryComponentNamed:@"param1" index:0]]);
  XCTAssertTrue([@"3" isEqualToString:[url wtQueryComponentNamed:@"param1" index:1]]);
  XCTAssertTrue(nil == [url wtQueryComponentNamed:@"param1" index:2]);
  XCTAssertTrue(nil == [url wtQueryComponentNamed:@"param1" index:-1]);
  XCTAssertTrue(nil == [url wtQueryComponentNamed:@"xxx" index:0]);
}

- (void)testSortedByCompareQueryComponents {
  NSURL *url = [NSURL URLWithString:@"sort?c=4&a=2&b=3&a=1"];
  
  NSURL *u = [url wtSortedByCompareQueryComponents];
  XCTAssertTrue([@"sort?a=2&a=1&b=3&c=4" isEqualToString:u.absoluteString]);
}

- (void)testRemoveQueries {
  NSURL *url = self.url;
  
  NSURL *u = [url wtRemoveQueries:@[@"param2"] caseSensitive:NO];
  XCTAssertTrue([u.absoluteString isEqualToString:@"https://www.wtfan.com:111111/NSURL/test?param1=1&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english"]);
  u = [url wtRemoveQueries:@[@"param2", @"param1"] caseSensitive:NO];
  XCTAssertTrue([u.absoluteString isEqualToString:@"https://www.wtfan.com:111111/NSURL/test?param3=%E4%B8%AD%E6%96%87&param3=english"]);
  u = [url wtRemoveQueries:@[@"Param2"] caseSensitive:YES];
  XCTAssertTrue([u.absoluteString isEqualToString:@"https://www.wtfan.com:111111/NSURL/test?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english"]);
  u = [url wtRemoveQueries:@[@"Param2", @"param1"] caseSensitive:YES];
  XCTAssertTrue([u.absoluteString isEqualToString:@"https://www.wtfan.com:111111/NSURL/test?param2=abc&param3=%E4%B8%AD%E6%96%87&param3=english"]);
}

- (void)testReplaces {
  NSURL *url = self.url;
  
  NSString *s = [[url wtReplaceScheme:@"http"] absoluteString];
  XCTAssertTrue([@"http://www.wtfan.com:111111/NSURL/test?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english" isEqualToString:s]);
  s = [[url wtReplaceScheme:nil] absoluteString];
  XCTAssertTrue([@"//www.wtfan.com:111111/NSURL/test?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english" isEqualToString:s]);
  
  s = [[url wtReplaceHost:@"www.fanwt.com"] absoluteString];
  XCTAssertTrue([@"https://www.fanwt.com:111111/NSURL/test?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english" isEqualToString:s]);
  s = [[url wtReplaceHost:nil] absoluteString];
  XCTAssertTrue([@"https://:111111/NSURL/test?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english" isEqualToString:s]);
  
  s = [[url wtReplacePort:@666666] absoluteString];
  XCTAssertTrue([@"https://www.wtfan.com:666666/NSURL/test?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english" isEqualToString:s]);
  s = [[url wtReplacePort:nil] absoluteString];
  XCTAssertTrue([@"https://www.wtfan.com/NSURL/test?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english" isEqualToString:s]);
  
  s = [[url wtReplacePath:@"/nsurl"] absoluteString];
  XCTAssertTrue([@"https://www.wtfan.com:111111/nsurl?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english" isEqualToString:s]);
  s = [[url wtReplacePath:nil] absoluteString];
  XCTAssertTrue([@"https://www.wtfan.com:111111?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english" isEqualToString:s]);
  s = [[url wtReplacePath:@"nsurl"] absoluteString];
  XCTAssertTrue(nil == s);
  
  s = [[url wtReplaceQuery:@{
    @"param1": @"value1",
    @"param2": @"ABC",
  }] absoluteString];
  XCTAssertTrue([@"https://www.wtfan.com:111111/NSURL/test?param2=ABC&param1=value1" isEqualToString:s]);
  s = [[url wtReplaceQuery:nil] absoluteString];
  XCTAssertTrue([@"https://www.wtfan.com:111111/NSURL/test" isEqualToString:s]);
}

- (void)testAbsoluteStringWithBaseUrlWithQueryString {
  NSURL *url = self.url;
  
  NSString *s = [url wtAbsoluteStringWithBaseUrl:YES withQueryString:YES];
  XCTAssertTrue([@"https://www.wtfan.com:111111/NSURL/test?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english" isEqualToString:s]);
  s = [url wtAbsoluteStringWithBaseUrl:YES withQueryString:NO];
  XCTAssertTrue([@"https://www.wtfan.com:111111/NSURL/test" isEqualToString:s]);
  s = [url wtAbsoluteStringWithBaseUrl:NO withQueryString:YES];
  XCTAssertTrue([@"NSURL/test?param1=1&param2=abc&param3=%E4%B8%AD%E6%96%87&param1=3&param3=english" isEqualToString:s]);
  s = [url wtAbsoluteStringWithBaseUrl:NO withQueryString:NO];
  XCTAssertTrue([@"NSURL/test" isEqualToString:s]);
}

@end

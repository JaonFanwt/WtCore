//
// NSString+WtExtension.m
// WtCore
//
// Created by wtfan on 2017/9/12.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import "NSString+WtExtension.h"


Class WTClassFromString(NSString *className) {
  Class c = NSClassFromString(className);
  if (c) return c;

  NSString *namespace = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
  c = NSClassFromString([NSString stringWithFormat:@"%@.%@", namespace, className]);
  return c;
}


@implementation NSString (WtExtension)

@end


@implementation NSString (WtHTML)

- (NSUInteger)wtIntegerValueFromHex {
  unsigned long result = 0;
  sscanf([self UTF8String], "%lx", &result);
  return (NSUInteger)result;
}

@end

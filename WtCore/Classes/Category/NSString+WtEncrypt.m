//
// NSString+WtEncrypt.m
// WtCore
//
// Created by wtfan on 2017/8/29.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import "NSString+WtEncrypt.h"

#import <CommonCrypto/CommonDigest.h>


NSString *wtStringFromMD5(NSString *str) {
  if (!str || str.length == 0 || ![str isKindOfClass:[NSString class]]) return nil;

  return [str wtStringFromMD5];
}


@implementation NSString (WtEncrypt)

- (NSString *)wtStringFromMD5 {
  if (self.length == 0) return nil;

  const char *value = [self UTF8String];

  unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
  CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);

  NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [outputString appendFormat:@"%02x", outputBuffer[i]];
  }

  return outputString;
}

@end

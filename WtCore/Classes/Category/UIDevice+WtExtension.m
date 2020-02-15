//
// UIDevice+WtExtension.m
// WtCore
//
// Created by wtfan on 2017/9/11.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import "UIDevice+WtExtension.h"


@implementation UIDevice (WtExtension)

- (BOOL)wtEqualOrGreaterThan:(NSInteger)iOSVersion {
  BOOL b = [[[UIDevice currentDevice] systemVersion] compare:[NSString stringWithFormat:@"%zd.0", iOSVersion] options:NSNumericSearch] != NSOrderedAscending;
  return b;
}

@end

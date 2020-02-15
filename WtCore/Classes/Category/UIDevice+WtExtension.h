//
// UIDevice+WtExtension.h
// WtCore
//
// Created by wtfan on 2017/9/11.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>


@interface UIDevice (WtExtension)

/// Returns a Boolean value that indicates whether current system version is equal or greater than the receiver.
/// @param iOSVersion The compared system version, e.g: 10.
- (BOOL)wtEqualOrGreaterThan:(NSInteger)iOSVersion;

@end

//
// NSString+WtEncrypt.h
// WtCore
//
// Created by wtfan on 2017/8/29.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>


/// Returns the md5 string from the receiver str.
/// @param str The receiver str.
NSString *wtStringFromMD5(NSString *str);


@interface NSString (WtEncrypt)

/// Returns the md5 string.
- (NSString *)wtStringFromMD5;

@end

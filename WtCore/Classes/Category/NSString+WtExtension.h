//
// NSString+WtExtension.h
// WtCore
//
// Created by wtfan on 2017/9/12.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>


/// Obtains a class by name.
/// Support Swift class.
/// @param className The name of a class.
Class WTClassFromString(NSString *className);


@interface NSString (WtExtension)

@end


@interface NSString (WtHTML)

/// Parses and returns unsigned integer from hex string.
- (NSUInteger)wtIntegerValueFromHex;

@end

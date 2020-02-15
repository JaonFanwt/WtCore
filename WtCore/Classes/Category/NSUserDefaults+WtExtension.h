//
// NSUserDefaults+WtExtension.h
// WtCore
//
// Created by wtfan on 2018/8/19.
// Copyright © 2018 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>


@interface NSUserDefaults (WtExtension)

/// Returns the object associated with the specified key, and using NSKeyedUnarchiver to unarchive object from data.
/// @param key A key in the current user's defaults database.
+ (id)wtGetValueWithKey:(NSString *)key;

/// Sets the value of the specified key, it will using NSKeyedUnarchiver to archive object to data, and saved in the current user's defaults database.
/// @param value The object to store in the defaults database.
/// @param key The key with which to associate the value.
+ (BOOL)wtSaveValue:(id)value key:(NSString *)key;

@end

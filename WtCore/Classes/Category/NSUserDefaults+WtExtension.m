//
// NSUserDefaults+WtExtension.m
// WtCore
//
// Created by wtfan on 2018/8/19.
// Copyright © 2018 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import "NSUserDefaults+WtExtension.h"


@implementation NSUserDefaults (WtExtension)

+ (id)wtGetValueWithKey:(NSString *)key {
  id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
  return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

+ (BOOL)wtSaveValue:(id)value key:(NSString *)key {
  if (!key) return NO;

  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
  if (!data) return NO;

  [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];

  return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

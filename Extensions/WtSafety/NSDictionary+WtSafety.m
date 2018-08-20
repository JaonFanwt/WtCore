//
//  NSDictionary+WtSafety.m
//  WtSafety
//
//  Created by fanwt on 03/04/2018.
//

#import "NSDictionary+WtSafety.h"

#import "WtSwizzle.h"
#import "WtSafetyLog.h"


@implementation NSDictionary (WtSafety)
+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    wt_swizzleSelector([self class], @selector(initWithObjects:forKeys:), @selector(wt_swizzleSafety_initWithObjects:forKeys:));
    wt_swizzleSelector([self class], @selector(initWithObjects:forKeys:count:), @selector(wt_swizzleSafety_initWithObjects:forKeys:count:));
    wt_swizzleClassStaticMethod([self class], @selector(dictionaryWithObjects:forKeys:), @selector(wt_swizzleSafety_dictionaryWithObjects:forKeys:));
    wt_swizzleClassStaticMethod([self class], @selector(dictionaryWithObjects:forKeys:count:), @selector(wt_swizzleSafety_dictionaryWithObjects:forKeys:count:));
  });
}

- (instancetype)wt_swizzleSafety_initWithObjects:(const id _Nonnull[_Nullable])objects forKeys:(const id<NSCopying> _Nonnull[_Nullable])keys count:(NSUInteger)cnt {
  id wrapKeys[cnt];
  id wrapObjects[cnt];
  int j = 0;
  for (int i = 0; i < cnt && j < cnt; i++) {
    id key = keys[i];
    id obj = objects[i];
    if (!key) {
      wtWarningCallStackSymbols();
      continue;
    }

    if (!obj) {
      wtWarningCallStackSymbols();
      continue;
    }
    wrapKeys[j] = key;
    wrapObjects[j] = obj;
    j++;
  }
  return [self wt_swizzleSafety_initWithObjects:wrapObjects forKeys:wrapKeys count:j];
}

- (instancetype)wt_swizzleSafety_initWithObjects:(NSArray<id> *)objects forKeys:(NSArray<id<NSCopying>> *)keys {
  NSUInteger cnt = keys.count;
  NSMutableArray<id<NSCopying>> *wrapKeys = @[].mutableCopy;
  NSMutableArray<id> *wrapObjects = @[].mutableCopy;
  int j = 0;
  for (int i = 0; i < cnt && j < cnt; i++) {
    id key = keys[i];
    if (!(i < objects.count)) break;
    id obj = objects[i];
    if (!key) {
      wtWarningCallStackSymbols();
      continue;
    }

    if (!obj) {
      wtWarningCallStackSymbols();
      continue;
    }
    wrapKeys[j] = key;
    wrapObjects[j] = obj;
    j++;
  }
  return [self wt_swizzleSafety_initWithObjects:wrapObjects forKeys:wrapKeys];
}

+ (instancetype)wt_swizzleSafety_dictionaryWithObjects:(NSArray<id> *)objects forKeys:(NSArray<id<NSCopying>> *)keys {
  NSUInteger cnt = keys.count;
  NSMutableArray<id<NSCopying>> *wrapKeys = @[].mutableCopy;
  NSMutableArray<id> *wrapObjects = @[].mutableCopy;
  int j = 0;
  for (int i = 0; i < cnt && j < cnt; i++) {
    id key = keys[i];
    if (!(i < objects.count)) break;
    id obj = objects[i];
    if (!key) {
      wtWarningCallStackSymbols();
      continue;
    }

    if (!obj) {
      wtWarningCallStackSymbols();
      continue;
    }
    wrapKeys[j] = key;
    wrapObjects[j] = obj;
    j++;
  }
  return [self wt_swizzleSafety_dictionaryWithObjects:wrapObjects forKeys:wrapKeys];
}

+ (instancetype)wt_swizzleSafety_dictionaryWithObjects:(const id _Nonnull[_Nullable])objects forKeys:(const id<NSCopying> _Nonnull[_Nullable])keys count:(NSUInteger)cnt {
  id wrapKeys[cnt];
  id wrapObjects[cnt];
  int j = 0;
  for (int i = 0; i < cnt && j < cnt; i++) {
    id key = keys[i];
    id obj = objects[i];
    if (!key) {
      wtWarningCallStackSymbols();
      continue;
    }

    if (!obj) {
      wtWarningCallStackSymbols();
      continue;
    }
    wrapKeys[j] = key;
    wrapObjects[j] = obj;
    j++;
  }
  return [self wt_swizzleSafety_dictionaryWithObjects:wrapObjects forKeys:wrapKeys count:j];
}
@end

//
//  NSDictionary+WtSafety.m
//  WtSafety
//
//  Created by fanwt on 03/04/2018.
//

#import "NSDictionary+WtSafety.h"

#import "WtSwizzle.h"
#import "WtSafetyLog.h"
#import "WtSafetyTool.h"

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
  if (cnt == 0) {
    return [self wt_swizzleSafety_initWithObjects:objects forKeys:keys count:cnt];
  }
  
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
  if (cnt == 0) {
    return [self wt_swizzleSafety_dictionaryWithObjects:objects forKeys:keys count:cnt];
  }

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

@implementation NSMutableDictionary (WtSafety)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    // 翻转bytes
    // __NSDictionaryM
    // setObject:forKey:
    // setObject:forKeyedSubscript:
    Class class = NSClassFromString(wtStringFromReversedChar((unsigned char []){0x4d, 0x79, 0x72, 0x61, 0x6e, 0x6f, 0x69, 0x74, 0x63, 0x69, 0x44, 0x53, 0x4e, 0x5f, 0x5f}, 15));
    wt_swizzleSelector(class, NSSelectorFromString(wtStringFromReversedChar((unsigned char []){0x3a, 0x79, 0x65, 0x4b, 0x72, 0x6f, 0x66, 0x3a, 0x74, 0x63, 0x65, 0x6a, 0x62, 0x4f, 0x74, 0x65, 0x73}, 17)), @selector(wt_swizzleSafety_setObject:forKey:));
    wt_swizzleSelector(class, NSSelectorFromString(wtStringFromReversedChar((unsigned char []){0x3a, 0x74, 0x70, 0x69, 0x72, 0x63, 0x73, 0x62, 0x75, 0x53, 0x64, 0x65, 0x79, 0x65, 0x4b, 0x72, 0x6f, 0x66, 0x3a, 0x74, 0x63, 0x65, 0x6a, 0x62, 0x4f, 0x74, 0x65, 0x73}, 28)), @selector(wt_swizzleSafety_setObject:forKeyedSubscript:));
  });
}

- (void)wt_swizzleSafety_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
  if (!aKey) {
    wtWarningCallStackSymbols();
    return;
  }
  if (!anObject) {
    [self removeObjectForKey:aKey];
    return;
  }

  [self wt_swizzleSafety_setObject:anObject forKey:aKey];
}

- (void)wt_swizzleSafety_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
  if (!key) {
    wtWarningCallStackSymbols();
    return;
  }
  if (!obj) {
    [self removeObjectForKey:key];
    return;
  }
  
  [self wt_swizzleSafety_setObject:obj forKeyedSubscript:key];
}

@end

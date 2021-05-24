//
//  NSArray+WtSafety.m
//  WtSafety
//
//  Created by fanwt on 03/04/2018.
//

#import "NSArray+WtSafety.h"

#import "WtSwizzle.h"
#import "WtSafetyLog.h"
#import "WtSafetyTool.h"


@implementation NSArray (WtSafety)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    wt_swizzleClassStaticMethod([self class], @selector(arrayWithObjects:count:), @selector(wt_swizzleSafety_arrayWithObjects:count:));
    wt_swizzleClassStaticMethod(self.class, @selector(arrayWithArray:), @selector(wt_swizzleSafety_arrayWithArray:));
  });
}

+ (instancetype)wt_swizzleSafety_arrayWithObjects:(const id _Nonnull[])objects count:(NSUInteger)cnt {
  if (cnt == 0) {
    return [self wt_swizzleSafety_arrayWithObjects:objects count:cnt];
  }

  id wrapObjects[cnt];
  int j = 0;
  for (int i = 0; i < cnt && j < cnt; i++) {
    if (objects[i]) {
      wrapObjects[j] = objects[i];
      j++;
    } else {
      wtWarningCallStackSymbols();
    }
  }
  return [self wt_swizzleSafety_arrayWithObjects:wrapObjects count:j];
}

+ (instancetype)wt_swizzleSafety_arrayWithArray:(NSArray *)array {
  return [self wt_swizzleSafety_arrayWithArray:array?:@[]];
}

@end


@implementation NSMutableArray (WtSafety)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    // 翻转bytes
    // __NSArrayM
    // addObject:
    // insertObject:atIndex:
    // replaceObjectAtIndex:withObject:
    // objectAtIndex:
    Class am = NSClassFromString(wtStringFromReversedChar((unsigned char []){0x4d, 0x79, 0x61, 0x72, 0x72, 0x41, 0x53, 0x4e, 0x5f, 0x5f}, 10));
    wt_swizzleSelector(am, NSSelectorFromString(wtStringFromReversedChar((unsigned char []){0x3a, 0x74, 0x63, 0x65, 0x6a, 0x62, 0x4f, 0x64, 0x64, 0x61}, 10)), @selector(wt_swizzleSafety_addObject:));
    wt_swizzleSelector(am, NSSelectorFromString(wtStringFromReversedChar((unsigned char []){0x3a, 0x78, 0x65, 0x64, 0x6e, 0x49, 0x74, 0x61, 0x3a, 0x74, 0x63, 0x65, 0x6a, 0x62, 0x4f, 0x74, 0x72, 0x65, 0x73, 0x6e, 0x69}, 21)), @selector(wt_swizzleSafety_insertObject:atIndex:));
    wt_swizzleSelector(am, NSSelectorFromString(wtStringFromReversedChar((unsigned char []){0x3a, 0x74, 0x63, 0x65, 0x6a, 0x62, 0x4f, 0x68, 0x74, 0x69, 0x77, 0x3a, 0x78, 0x65, 0x64, 0x6e, 0x49, 0x74, 0x41, 0x74, 0x63, 0x65, 0x6a, 0x62, 0x4f, 0x65, 0x63, 0x61, 0x6c, 0x70, 0x65, 0x72}, 32)), @selector(wt_swizzleSafety_replaceObjectAtIndex:withObject:));
    wt_swizzleSelector(am, NSSelectorFromString(wtStringFromReversedChar((unsigned char []){0x3a, 0x78, 0x65, 0x64, 0x6e, 0x49, 0x74, 0x41, 0x74, 0x63, 0x65, 0x6a, 0x62, 0x6f}, 14)), @selector(wt_swizzleSafety_objectAtIndex:));
  });
}

- (void)wt_swizzleSafety_addObject:(id)anObject {
  if (!anObject) {
    wtWarningCallStackSymbols();
    return;
  }

  [self wt_swizzleSafety_addObject:anObject];
}

- (void)wt_swizzleSafety_insertObject:(id)anObject atIndex:(NSUInteger)index {
  if (!anObject) {
    wtWarningCallStackSymbols();
    return;
  }

  [self wt_swizzleSafety_insertObject:anObject atIndex:index];
}

- (void)wt_swizzleSafety_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
  if (!anObject) {
    wtWarningCallStackSymbols();
    return;
  }

  [self wt_swizzleSafety_replaceObjectAtIndex:index withObject:anObject];
}

- (id)wt_swizzleSafety_objectAtIndex:(NSUInteger)index {
  if (index < self.count) {
    return [self wt_swizzleSafety_objectAtIndex:index];
  }
  wtWarningCallStackSymbols();
  return nil;
}

@end

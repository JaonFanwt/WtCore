//
//  NSArray+WtSafety.m
//  WtSafety
//
//  Created by fanwt on 03/04/2018.
//

#import "NSArray+WtSafety.h"

#import "WtSwizzle.h"
#import "WtSafetyLog.h"


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
    Class am = NSClassFromString(@"__NSArrayM");
    wt_swizzleSelector(am, @selector(addObject:), @selector(wt_swizzleSafety_addObject:));
    wt_swizzleSelector(am, @selector(insertObject:atIndex:), @selector(wt_swizzleSafety_insertObject:atIndex:));
    wt_swizzleSelector(am, @selector(replaceObjectAtIndex:withObject:), @selector(wt_swizzleSafety_replaceObjectAtIndex:withObject:));
  });
}

- (void)wt_swizzleSafety_addObject:(id)anObject {
  if (!anObject) return;

  [self wt_swizzleSafety_addObject:anObject];
}

- (void)wt_swizzleSafety_insertObject:(id)anObject atIndex:(NSUInteger)index {
  if (!anObject) return;

  [self wt_swizzleSafety_insertObject:anObject atIndex:index];
}

- (void)wt_swizzleSafety_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
  if (!anObject) return;

  [self wt_swizzleSafety_replaceObjectAtIndex:index withObject:anObject];
}

@end

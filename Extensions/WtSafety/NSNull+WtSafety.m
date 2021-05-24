//
//  NSNull+WtSafety.m
//  WtCore
//
//  Created by fanweitian on 2021/5/24.
//

#import "NSNull+WtSafety.h"

#import "WtSwizzle.h"


@implementation NSNull (WtSafety)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    wt_swizzleSelector(self.class, @selector(methodSignatureForSelector:), @selector(gl_methodSignatureForSelector:));
    wt_swizzleSelector(self.class, @selector(forwardInvocation:), @selector(gl_forwardInvocation:));
  });
}

- (NSMethodSignature *)gl_methodSignatureForSelector:(SEL)aSelector {
  NSMethodSignature *sig = [self gl_methodSignatureForSelector:aSelector];
  if (sig) {
    return sig;
  }
  return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)gl_forwardInvocation:(NSInvocation *)anInvocation {
  NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
  if (!returnLength) {
    // nothing to do
    return;
  }

  // set return value to all zero bits
  char buffer[returnLength];
  memset(buffer, 0, returnLength);

  [anInvocation setReturnValue:buffer];
}

@end

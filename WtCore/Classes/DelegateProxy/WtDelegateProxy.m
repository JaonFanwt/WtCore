//
// WtDelegateProxy.m
// WtCore
//
// Created by wtfan on 2017/7/29.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import "WtDelegateProxy.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "CTBlockDescription.h"
#import "UIDevice+WtExtension.h"

NSString *wtExtractStructName(NSString *typeEncodeString) {
  if (!typeEncodeString || ![typeEncodeString isKindOfClass:[NSString class]]) {
    return @"";
  }

  NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
  NSString *typeString = array[0];
  int firstValidIndex = 0;
  for (int i = 0; i < typeString.length; i++) {
    char c = [typeString characterAtIndex:i];
    if (c == '{' || c == '_') {
      firstValidIndex++;
    } else {
      break;
    }
  }
  return [typeString substringFromIndex:firstValidIndex];
}


@interface WtDelegateProxy () {
  Protocol *_protocol;
}
@end


@implementation WtDelegateProxy

- (instancetype)initWithProtocol:(Protocol *)protocol {
  NSCParameterAssert(protocol != NULL);

  self = [super init];
  if (self == nil) return nil;

  class_addProtocol(self.class, protocol);

  _protocol = protocol;

  return self;
}

- (void)selector:(SEL)selector block:(id)block {
  if (!selector) return;

  CTBlockDescription *blockDescription = [[CTBlockDescription alloc] initWithBlock:block];
  objc_setAssociatedObject(self, selector, blockDescription, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CTBlockDescription *)blockDescriptionWithSelector:(SEL)selector {
  if (!selector) return nil;

  return objc_getAssociatedObject(self, selector);
}

- (void)forwardInvocation:(NSInvocation *)invocation {
  if (_delegate && ![_delegate isKindOfClass:self.class] && [_delegate respondsToSelector:invocation.selector]) {
    [invocation invokeWithTarget:_delegate];
  }
  
  CTBlockDescription *blockDescription = [self blockDescriptionWithSelector:[invocation selector]];
  if (blockDescription) {
    NSMethodSignature *blockMethodSignature = blockDescription.blockSignature;
    NSInvocation *blockInvocation = [NSInvocation invocationWithMethodSignature:blockMethodSignature];

    // IMP       ->     block
    // 0 self           0 block
    // 1 selector       1 argument1
    // 2 argument1
    for (NSInteger i = 2; i < invocation.methodSignature.numberOfArguments; i++) {
      const char *argumentType = [invocation.methodSignature getArgumentTypeAtIndex:i];
      switch (argumentType[0] == 'r' ? argumentType[1] : argumentType[0]) {
#define WT_FF_ARG_CASE(_typeChar, _type)              \
  case _typeChar: {                                   \
    _type arg;                                        \
    [invocation getArgument:&arg atIndex:i];          \
    [blockInvocation setArgument:&arg atIndex:i - 1]; \
    break;                                            \
  }
        WT_FF_ARG_CASE('c', char);
        WT_FF_ARG_CASE('C', unsigned char);
        WT_FF_ARG_CASE('s', short);
        WT_FF_ARG_CASE('S', unsigned short);
        WT_FF_ARG_CASE('i', int);
        WT_FF_ARG_CASE('I', unsigned int);
        WT_FF_ARG_CASE('l', long);
        WT_FF_ARG_CASE('L', unsigned long);
        WT_FF_ARG_CASE('q', long long);
        WT_FF_ARG_CASE('Q', unsigned long long);
        WT_FF_ARG_CASE('f', float);
        WT_FF_ARG_CASE('d', double);
        WT_FF_ARG_CASE('B', BOOL);
        case '@': {
          __unsafe_unretained id arg;
          [invocation getArgument:&arg atIndex:i];
          [blockInvocation setArgument:&arg atIndex:i - 1];
          break;
        }
        case '{': {
          NSString *typeString = wtExtractStructName([NSString stringWithUTF8String:argumentType]);
#define WT_FF_ARG_STRUCT(_type)                                     \
  if ([typeString rangeOfString:@ #_type].location != NSNotFound) { \
    _type arg;                                                      \
    [invocation getArgument:&arg atIndex:i];                        \
    [blockInvocation setArgument:&arg atIndex:i - 1];               \
    break;                                                          \
  }
          WT_FF_ARG_STRUCT(NSRange);
          WT_FF_ARG_STRUCT(CGPoint);
          WT_FF_ARG_STRUCT(CGVector);
          WT_FF_ARG_STRUCT(CGSize);
          WT_FF_ARG_STRUCT(CGRect);
          WT_FF_ARG_STRUCT(CGAffineTransform);
          WT_FF_ARG_STRUCT(UIEdgeInsets);
          WT_FF_ARG_STRUCT(UIOffset);
          if (@available(iOS 11.0, *)) {
            WT_FF_ARG_STRUCT(NSDirectionalEdgeInsets)
          }

          break;
        }
        case ':': {
          SEL selector;
          [invocation getArgument:&selector atIndex:i];
          [blockInvocation setArgument:&selector atIndex:i - 1];
          break;
        }
        case '^':
        case '*': {
          void *arg;
          [invocation getArgument:&arg atIndex:i];
          [blockInvocation setArgument:&arg atIndex:i - 1];
          break;
        }
        case '#': {
          Class arg;
          [invocation getArgument:&arg atIndex:i];
          [blockInvocation setArgument:&arg atIndex:i - 1];
          break;
        }
        default: {
#ifdef DEBUG
          NSLog(@"error type %s", argumentType);
#endif
          break;
        }
      }
    }

    if (blockMethodSignature.methodReturnLength > 0) {
      [blockInvocation invokeWithTarget:blockDescription.block];

      const char *returnType = [invocation.methodSignature methodReturnType];
      const char *realReturnType = [blockInvocation.methodSignature methodReturnType];

      switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
#define WT_FF_RET_SMART_CONVERT(_typeChar, _realType, _type) \
  case _typeChar: {                                          \
    _realType result;                                        \
    [blockInvocation getReturnValue:&result];                \
    _type convertResult = (_type)result;                     \
    [invocation setReturnValue:&convertResult];              \
    break;                                                   \
  }

#define WT_FF_RET_CASE(_typeChar, _type)                                        \
  case _typeChar: {                                                             \
    switch (realReturnType[0] == 'r' ? realReturnType[1] : realReturnType[0]) { \
      WT_FF_RET_SMART_CONVERT('c', char, _type)                                 \
      WT_FF_RET_SMART_CONVERT('C', unsigned char, _type)                        \
      WT_FF_RET_SMART_CONVERT('s', short, _type)                                \
      WT_FF_RET_SMART_CONVERT('S', unsigned short, _type)                       \
      WT_FF_RET_SMART_CONVERT('i', int, _type)                                  \
      WT_FF_RET_SMART_CONVERT('I', unsigned int, _type)                         \
      WT_FF_RET_SMART_CONVERT('l', long, _type)                                 \
      WT_FF_RET_SMART_CONVERT('L', unsigned long, _type)                        \
      WT_FF_RET_SMART_CONVERT('q', long long, _type)                            \
      WT_FF_RET_SMART_CONVERT('Q', unsigned long long, _type)                   \
      WT_FF_RET_SMART_CONVERT('f', float, _type)                                \
      WT_FF_RET_SMART_CONVERT('d', double, _type)                               \
      WT_FF_RET_SMART_CONVERT('B', BOOL, _type)                                 \
    }                                                                           \
    break;                                                                      \
  }
        WT_FF_RET_CASE('c', char);
        WT_FF_RET_CASE('C', unsigned char);
        WT_FF_RET_CASE('s', short);
        WT_FF_RET_CASE('S', unsigned short);
        WT_FF_RET_CASE('i', int);
        WT_FF_RET_CASE('I', unsigned int);
        WT_FF_RET_CASE('l', long);
        WT_FF_RET_CASE('L', unsigned long);
        WT_FF_RET_CASE('q', long long);
        WT_FF_RET_CASE('Q', unsigned long long);
        WT_FF_RET_CASE('f', float);
        WT_FF_RET_CASE('d', double);
        WT_FF_RET_CASE('B', BOOL);
        case '{': {
          NSString *typeString = wtExtractStructName([NSString stringWithUTF8String:returnType]);
#define WT_FF_RET_STRUCT(_type)                                     \
  if ([typeString rangeOfString:@ #_type].location != NSNotFound) { \
    _type result;                                                   \
    [blockInvocation getReturnValue:&result];                       \
    [invocation setReturnValue:&result];                            \
    break;                                                          \
  }
          WT_FF_RET_STRUCT(NSRange);
          WT_FF_RET_STRUCT(CGPoint);
          WT_FF_RET_STRUCT(CGVector);
          WT_FF_RET_STRUCT(CGSize);
          WT_FF_RET_STRUCT(CGRect);
          WT_FF_RET_STRUCT(CGAffineTransform);
          WT_FF_RET_STRUCT(UIEdgeInsets);
          WT_FF_RET_STRUCT(UIOffset);
          if (@available(iOS 11.0, *)) {
            WT_FF_RET_STRUCT(NSDirectionalEdgeInsets)
          }

          break;
        }
        case '@': {
          __unsafe_unretained id result;
          [blockInvocation getReturnValue:&result];
          [invocation setReturnValue:&result];
          break;
        }
        case ':': {
          SEL selector;
          [blockInvocation getReturnValue:&selector];
          [invocation setReturnValue:&selector];
          break;
        }
        case '*':
        case '^': {
          void *result;
          [blockInvocation getReturnValue:&result];
          [invocation setReturnValue:&result];
          break;
        }
        case '#': {
          Class result;
          [blockInvocation getReturnValue:&result];
          [invocation setReturnValue:&result];
          break;
        }
        default: {
#ifdef DEBUG
          NSLog(@"error type %s", returnType);
#endif
          break;
        }
      }
    } else {
      [blockInvocation invokeWithTarget:blockDescription.block];
    }
  }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
  struct objc_method_description methodDescription = protocol_getMethodDescription(_protocol, selector, NO, YES);
  
  if (methodDescription.name == NULL) {
    methodDescription = protocol_getMethodDescription(_protocol, selector, YES, YES);
    if (methodDescription.name == NULL && _delegate && [_delegate respondsToSelector:selector]) {
      return [_delegate methodSignatureForSelector:selector];
    } else { }
  }
  
  NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
  return methodSignature;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  BOOL b = [super respondsToSelector:aSelector];

  if (!b) {
    CTBlockDescription *blockDescription = [self blockDescriptionWithSelector:aSelector];
    if (blockDescription) {
      return YES;
    }
  }
  
  if (_delegate && ![_delegate isKindOfClass:self.class] && [_delegate respondsToSelector:aSelector]) {
    return YES;
  }

  return b;
}

@end

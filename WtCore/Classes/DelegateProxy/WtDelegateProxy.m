//
//  WtDelegateProxy.m
//  WtDelegateProxy
//
//  Created by wtfan on 2017/7/29.
//  Copyright © 2017年 wtfan(long). All rights reserved.
//

#import "WtDelegateProxy.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "CTBlockDescription.h"

static NSString *wtExtractStructName(NSString *typeEncodeString) {
    if (!typeEncodeString || ![typeEncodeString isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
    NSString *typeString = array[0];
    int firstValidIndex = 0;
    for (int i = 0; i< typeString.length; i++) {
        char c = [typeString characterAtIndex:i];
        if (c == '{' || c=='_') {
            firstValidIndex++;
        }else {
            break;
        }
    }
    return [typeString substringFromIndex:firstValidIndex];
}

@interface WtDelegateProxy (){
    Protocol *_protocol;
}
@end

@implementation WtDelegateProxy
- (void)dealloc {
    NSLog(@"%s - %@", __func__, self);
}

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
#define WT_FF_ARG_CASE(_typeChar, _type) \
case _typeChar: { \
    _type arg; \
    [invocation getArgument:&arg atIndex:i]; \
    [blockInvocation setArgument:&arg atIndex:i-1]; \
    break; \
}
                WT_FF_ARG_CASE('c', char)
                WT_FF_ARG_CASE('C', unsigned char)
                WT_FF_ARG_CASE('s', short)
                WT_FF_ARG_CASE('S', unsigned short)
                WT_FF_ARG_CASE('i', int)
                WT_FF_ARG_CASE('I', unsigned int)
                WT_FF_ARG_CASE('l', long)
                WT_FF_ARG_CASE('L', unsigned long)
                WT_FF_ARG_CASE('q', long long)
                WT_FF_ARG_CASE('Q', unsigned long long)
                WT_FF_ARG_CASE('f', float)
                WT_FF_ARG_CASE('d', double)
                WT_FF_ARG_CASE('B', BOOL)
                case '@': {
                    __unsafe_unretained id arg;
                    [invocation getArgument:&arg atIndex:i];
                    [blockInvocation setArgument:&arg atIndex:i-1];
                    break;
                }
                case '{': {
                    NSString *typeString = wtExtractStructName([NSString stringWithUTF8String:argumentType]);
#define WT_FF_ARG_STRUCT(_type, _transFunc) \
if ([typeString rangeOfString:@#_type].location != NSNotFound) { \
    _type arg; \
    [invocation getArgument:&arg atIndex:i]; \
    [blockInvocation setArgument:&arg atIndex:i-1]; \
    break; \
}
                    WT_FF_ARG_STRUCT(CGRect, valueWithRect)
                    WT_FF_ARG_STRUCT(CGPoint, valueWithPoint)
                    WT_FF_ARG_STRUCT(CGSize, valueWithSize)
                    WT_FF_ARG_STRUCT(NSRange, valueWithRange)
                    break;
                }
                case ':': {
                    SEL selector;
                    [invocation getArgument:&selector atIndex:i];
                    [blockInvocation setArgument:&selector atIndex:i-1];
                    break;
                }
                case '^':
                case '*': {
                    void *arg;
                    [invocation getArgument:&arg atIndex:i];
                    [blockInvocation setArgument:&arg atIndex:i-1];
                    break;
                }
                case '#': {
                    Class arg;
                    [invocation getArgument:&arg atIndex:i];
                    [blockInvocation setArgument:&arg atIndex:i-1];
                    break;
                }
                default: {
                    NSLog(@"error type %s", argumentType);
                    break;
                }
            }
        }
        
        if (blockMethodSignature.methodReturnLength > 0) {
            void *returnValue;
            [blockInvocation invokeWithTarget:blockDescription.block];
            [blockInvocation getReturnValue:&returnValue];
            
            [invocation setReturnValue:&returnValue];
        }else {
            [blockInvocation invokeWithTarget:blockDescription.block];
        }
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    struct objc_method_description methodDescription = protocol_getMethodDescription(_protocol, selector, NO, YES);
    
    if (methodDescription.name == NULL) {
        methodDescription = protocol_getMethodDescription(_protocol, selector, YES, YES);
        if (methodDescription.name == NULL) return [super methodSignatureForSelector:selector];
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
    
    return b;
}

@end

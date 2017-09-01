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
        for (int i = 2; i < invocation.methodSignature.numberOfArguments; i++) {
            void *argument;
            [invocation getArgument:&argument atIndex:i];
            [blockInvocation setArgument:&argument atIndex:i-1];
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

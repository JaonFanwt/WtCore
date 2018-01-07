//
//  UIControl+WtUI.m
//  WtUI
//
//  Created by wtfan on 2017/9/8.
//
//

#import "UIControl+WtUI.h"

#import <objc/runtime.h>

@implementation UIControl (WtUI)

- (WtDelegateProxy<WtControlProtocol> *)wtDelegateProxy {
    WtDelegateProxy<WtControlProtocol> *__delegateProxy = objc_getAssociatedObject(self, _cmd);
    
    if (!__delegateProxy) {
        __delegateProxy = (WtDelegateProxy<WtControlProtocol> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(WtControlProtocol)];
        objc_setAssociatedObject(self, _cmd, __delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return __delegateProxy;
}

- (void)wtAction:(void (^)(UIControl *control, UIControlEvents controlEvents))block forControlEvents:(UIControlEvents)controlEvents {
    [[self wtDelegateProxy] selector:@selector(wtAction:controlEvents:) block:block];
    [self addTarget:[self wtDelegateProxy] action:@selector(wtAction:controlEvents:) forControlEvents:controlEvents];
}

@end

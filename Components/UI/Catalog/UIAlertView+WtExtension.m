//
//  UIAlertView+WtExtension.m
//  Pods
//
//  Created by wtfan on 2017/9/8.
//
//

#import "UIAlertView+WtExtension.h"

#import <objc/runtime.h>

@implementation UIAlertView (WtExtension)
- (WtDelegateProxy<UIAlertViewDelegate> *)wtDelegateProxy {
    WtDelegateProxy<UIAlertViewDelegate> *__delegateProxy = objc_getAssociatedObject(self, _cmd);
    
    if (!__delegateProxy) {
        __delegateProxy = (WtDelegateProxy<UIAlertViewDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UIAlertViewDelegate)];
        objc_setAssociatedObject(self, _cmd, __delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = __delegateProxy;
    }
    
    return __delegateProxy;
}
@end

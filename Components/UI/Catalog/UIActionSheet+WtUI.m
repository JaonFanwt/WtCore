//
//  UIActionSheet+WtUI.m
//  WtUI
//
//  Created by wtfan on 2017/9/8.
//
//

#import "UIActionSheet+WtUI.h"

#import <objc/runtime.h>

@implementation UIActionSheet (WtUI)
- (WtDelegateProxy<UIActionSheetDelegate> *)wtDelegateProxy {
    WtDelegateProxy<UIActionSheetDelegate> *__delegateProxy = objc_getAssociatedObject(self, _cmd);
    
    if (!__delegateProxy) {
        __delegateProxy = (WtDelegateProxy<UIActionSheetDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UIActionSheetDelegate)];
        objc_setAssociatedObject(self, _cmd, __delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = __delegateProxy;
    }
    
    return __delegateProxy;
}
@end

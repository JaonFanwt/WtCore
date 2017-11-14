//
//  WtViewModel.m
//  WtUI
//
//  Created by wtfan on 2017/9/11.
//
//

#import "WtViewModel.h"

#import <objc/runtime.h>

@implementation WtViewModel
- (WtDelegateProxy<UIViewControllerPreviewingDelegate> *)previewingDelegate {
    WtDelegateProxy<UIViewControllerPreviewingDelegate> *proxy = objc_getAssociatedObject(self, _cmd);
    if (!proxy) {
        proxy = (WtDelegateProxy<UIViewControllerPreviewingDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UIViewControllerPreviewingDelegate)];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return proxy;
}
@end

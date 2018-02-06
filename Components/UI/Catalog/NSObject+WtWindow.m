//
//  NSObject+WtWindow.m
//  Pods
//
//  Created by fanwt on 06/02/2018.
//

#import "NSObject+WtWindow.h"

#import "WtWindow.h"

@implementation NSObject (WtWindow)
- (UIWindow *)wtTopWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isMemberOfClass:[WtWindow class]] && !window.isHidden){
            return window;
        }
    }
    
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([NSStringFromClass([window class]) isEqualToString:@"UIWindow"] && !window.isHidden) {
            return window;
        }
    }
    
    if ([UIApplication sharedApplication].windows.count > 0) {
        return [UIApplication sharedApplication].windows[0];
    }
    
    return nil;
}

- (UIViewController *)wtTopViewController {
    UIWindow *window = [self wtTopWindow];
    
    UIViewController *viewCtrl = nil;
    if (window.rootViewController && [window.rootViewController isKindOfClass:[UINavigationController class]]) {
        viewCtrl = [(UINavigationController *)window.rootViewController topViewController];
    }
    
    if (viewCtrl.presentationController) {
        if ([viewCtrl.presentationController isKindOfClass:[UINavigationController class]]) {
            viewCtrl = [(UINavigationController *)viewCtrl topViewController];
        }
    }
    
    return viewCtrl;
}
@end

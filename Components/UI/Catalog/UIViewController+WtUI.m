//
//  UIViewController+WtUI.m
//  WtCore
//
//  Created by fanwt on 07/02/2018.
//

#import "UIViewController+WtUI.h"

@implementation UIViewController (WtUI)
- (UIViewController *)wtTopViewController {
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)self topViewController] wtTopViewController];
    }else if ([self isKindOfClass:[UITabBarController class]]) {
        return [[(UITabBarController*)self selectedViewController] wtTopViewController];
    }
    
    if (self.presentedViewController) {
        return [self.presentedViewController wtTopViewController];
    }
    
    return self;
}
@end

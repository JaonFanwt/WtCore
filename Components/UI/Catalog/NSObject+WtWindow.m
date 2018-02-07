//
//  NSObject+WtWindow.m
//  WtCore
//
//  Created by fanwt on 06/02/2018.
//

#import "NSObject+WtWindow.h"

#import "WtWindow.h"
#import "UIWindow+WtWindow.h"
#import "UIViewController+WtUI.h"

@implementation NSObject (WtWindow)
- (UIWindow *)wtTopWindow {
    return [UIWindow wtTopWindow];
}

- (UIViewController *)wtTopViewController {
    UIWindow *window = [self wtTopWindow];
    
    return [window.rootViewController wtTopViewController];
}
@end

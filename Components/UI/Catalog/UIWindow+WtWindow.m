//
//  UIWindow+WtWindow.m
//  WtCore
//
//  Created by fanwt on 07/02/2018.
//

#import "UIWindow+WtWindow.h"

#import "WtWindow.h"
#import "UIViewController+WtUI.h"


@implementation UIWindow (WtWindow)
+ (UIWindow *)wtTopWindow {
  NSArray *windows = [UIApplication sharedApplication].windows;
  for (UIWindow *window in [windows reverseObjectEnumerator]) {
    if ([window isMemberOfClass:[WtWindow class]] && !window.isHidden) {
      BOOL isHUD = ((WtWindow *)window).windowAlert.isHUD;
      if (!isHUD) return window;
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

- (UIWindow *)wtPreWindow {
  NSArray *windows = [UIApplication sharedApplication].windows;
  NSUInteger idx = [windows indexOfObject:self];
  if (idx == 0) return nil;

  for (int i = (int)(idx - 1); i >= 0; i--) {
    UIWindow *window = windows[i];
    if ([window isMemberOfClass:[WtWindow class]] && !window.isHidden) {
      BOOL isHUD = ((WtWindow *)window).windowAlert.isHUD;
      if (!isHUD) return window;
    }
  }

  for (int i = (int)(idx - 1); i >= 0; i--) {
    UIWindow *window = windows[i];
    if ([NSStringFromClass([window class]) isEqualToString:@"UIWindow"] && !window.isHidden) {
      return window;
    }
  }

  return nil;
}

- (UIViewController *)wtTopViewController {
  UIWindow *window = self;

  return [window.rootViewController wtTopViewController];
}
@end

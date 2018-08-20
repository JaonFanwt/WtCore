//
//  UIWindow+WtWindow.h
//  WtCore
//
//  Created by fanwt on 07/02/2018.
//

#import <UIKit/UIKit.h>


@interface UIWindow (WtWindow)
+ (UIWindow *)wtTopWindow;
- (UIWindow *)wtPreWindow;
- (UIViewController *)wtTopViewController;
@end

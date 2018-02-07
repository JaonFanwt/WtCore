//
//  NSObject+WtWindow.h
//  WtCore
//
//  Created by fanwt on 06/02/2018.
//

#import <UIKit/UIKit.h>

@interface NSObject (WtWindow)
- (UIWindow *)wtTopWindow;
- (UIViewController *)wtTopViewController;
@end

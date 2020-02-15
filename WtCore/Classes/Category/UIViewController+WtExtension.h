//
// UIViewController+WtExtension.h
// WtCore
//
// Created by wtfan on 2018/1/2.
// Copyright © 2018 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>


@interface UIViewController (WtExtension)

/// Finds and returns the previous view controller in the navigation stack.
- (UIViewController *)wtPreviousViewController;

/// Pushes a view controller onto the receiver's stack and updates the display and pops the history view controllers at the top of the navigation stack using rid num.
/// @param toViewCtrl The view controller to push onto the stack.
/// @param animated Specify YES to animate the transition or NO if you do not want the transition to be animated.
/// @param getRidNum The number of pop history view controllers.
- (void)wtPushViewController:(UIViewController *)toViewCtrl animated:(BOOL)animated getRidNum:(NSUInteger)getRidNum;

@end

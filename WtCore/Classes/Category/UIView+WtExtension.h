//
// UIView+WtExtension.h
// WtCore
//
// Created by wtfan on 2017/9/12.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>


@interface UIView (WtExtension)

/// Finds and returns the first view controller of the view.
- (UIViewController *)wtFirstViewController;

/// Finds and returns the first super view of the view by the class of the super view.
/// @param cls The class of the super view.
- (UIView *)wtFirstSuperViewWithClass:(Class)cls;

/// Finds and returns the first sub view of the view by the class of the sub view.
/// @param cls The class of the sub view.
- (UIView *)wtFirstSubViewWithClass:(Class)cls;

@end

//
//  UIGestureRecognizer+WtUI.h
//  WtCore
//
//  Created by wtfan on 2018/1/7.
//

@import Foundation;
@import UIKit;


@interface UIGestureRecognizer (WtUI)
+ (instancetype)wtWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block;
@end

//
//  UIView+WtUI.m
//  WtCore
//
//  Created by wtfan on 2018/1/7.
//

#import "UIView+WtUI.h"

#import <objc/runtime.h>

#import "WtDispatch.h"
#import "UIGestureRecognizer+WtUI.h"

@implementation UIView (WtUI)

#pragma mark public
- (void)wtWhenTapped:(void (^)(void))block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer wtWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        wtDispatch_in_main(block);
    }];
    [self addGestureRecognizer:tapGesture];
}
@end

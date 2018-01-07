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

    UITapGestureRecognizer *tapGesture = objc_getAssociatedObject(self, _cmd);
    if (tapGesture) {
        [self removeGestureRecognizer:tapGesture];
    }

    tapGesture = [UITapGestureRecognizer wtWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        wtDispatch_in_main(block);
    }];
    objc_setAssociatedObject(self, _cmd, tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addGestureRecognizer:tapGesture];
}
@end

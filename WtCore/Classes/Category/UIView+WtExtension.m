//
//  UIView+WtExtension.m
//  WtCore
//
//  Created by wtfan on 2017/9/12.
//
//

#import "UIView+WtExtension.h"

@implementation UIView (WtExtension)
- (UIViewController *)wtFirstViewController {
    return (UIViewController *)[self wtTraverseResponderChainForUIViewController];
}

- (id)wtTraverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder wtTraverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end

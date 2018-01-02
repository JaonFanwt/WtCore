//
//  UIViewController+WtExtension.m
//  WtCore
//
//  Created by wtfan on 2018/1/2.
//

#import "UIViewController+WtExtension.h"

@implementation UIViewController (WtExtension)
- (UIViewController *)wtPreviousViewController {
    NSArray *vcStack = self.navigationController.viewControllers;
    NSInteger selfIdx = [vcStack indexOfObject:self];
    if (vcStack.count < 2 || selfIdx == NSNotFound) { return nil; }
    return (UIViewController *)[vcStack objectAtIndex:selfIdx - 1];
}

- (void)wtPushViewController:(UIViewController *)toViewCtrl animated:(BOOL)animated getRidNum:(NSUInteger)getRidNum {
    UINavigationController *navgationController = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        navgationController = (UINavigationController *)self;
    }else {
        navgationController = self.navigationController;
    }
    if (!navgationController) return;

    NSArray *vcStack = self.navigationController.viewControllers;
    if (vcStack.count == 0) return;
    if (getRidNum > vcStack.count - 1) getRidNum = vcStack.count - 1;

    if (getRidNum == 0) {
        [navgationController pushViewController:toViewCtrl animated:animated];
    }else {
        NSMutableArray *newStack = [vcStack subarrayWithRange:NSMakeRange(0, vcStack.count - getRidNum)].mutableCopy;
        [newStack addObject:toViewCtrl];
        [navgationController setViewControllers:newStack animated:animated];
    }
}
@end

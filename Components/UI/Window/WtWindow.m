//
//  WtWindow.m
//  WtUI
//
//  Created by wtfan on 2017/10/31.
//

#import "WtWindow.h"

#import "UIViewController+WtWindowAlert.h"
#import "UIView+WtExtension.h"

@implementation WtWindow
- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)wtCloseWithCompletion:(void (^)(BOOL finished))completion {
    UIViewController *firstViewController = self.rootViewController;
    [self.windowAlert closeAnimateWithDuration:kWtWindowAlertShowAnimationDurationTime
                                    animations:^{
                                        CGRect f = firstViewController.view.frame;
                                        firstViewController.view.transform = CGAffineTransformMakeTranslation(0, f.size.height);
                                    } completion:^(BOOL finished) {
                                        if (completion) {
                                            completion(finished);
                                        }
                                    }];
}
@end

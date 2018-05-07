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

- (void)wtCustomCloseWithCompletion:(void (^)(BOOL finished))completion {
    [self.windowAlert closeAnimateWithDuration:0
                                    animations:nil
                                    completion:^(BOOL finished) {
                                        if (completion) {
                                            completion(finished);
                                        }
                                    }];
}
@end

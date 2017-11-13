//
//  UIViewController+WtWindowAlert.m
//  FDFullscreenPopGesture
//
//  Created by wtfan on 2017/11/13.
//

#import "UIViewController+WtWindowAlert.h"

#import <objc/runtime.h>

#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

#import "WtWindowAlert.h"

@implementation UIViewController (WtWindowAlert)
- (WtWindowAlert *)wt_WindowAlert {
    WtWindowAlert *wa = objc_getAssociatedObject(self, _cmd);
    if (!wa) {
        wa = [[WtWindowAlert alloc] init];
        objc_setAssociatedObject(self, _cmd, wa, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return wa;
}

- (void)wt_showWithCompletion:(void (^)(BOOL finished))completion navigationBarHidden:(BOOL)hidden {
    UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:self];
    navCtrl.view.backgroundColor = [UIColor clearColor];
    self.fd_prefersNavigationBarHidden = hidden;
    [self.wt_WindowAlert showViewController:navCtrl
                        animateWithDuration:kWtWindowAlertShowAnimationDurationTime
                            backgroundColor:[UIColor clearColor]
                           beforeAnimations:^{
                               CGRect f = navCtrl.view.frame;
                               f.origin.y = f.size.height;
                               navCtrl.view.frame = f;
                           } animations:^{
                               CGRect f = navCtrl.view.frame;
                               f.origin.y = 0;
                               navCtrl.view.frame = f;
                           } completion:^(BOOL finished) {
                               if (completion) {
                                   completion(finished);
                               }
                           }];
}

- (void)wt_closeWithCompletion:(void (^)(BOOL finished))completion {
    [self.wt_WindowAlert closeAnimateWithDuration:kWtWindowAlertShowAnimationDurationTime
                                       animations:^{
                                           CGRect f = self.navigationController.view.frame;
                                           self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, f.size.height);
                                       } completion:^(BOOL finished) {
                                           if (completion) {
                                               completion(finished);
                                           }
                                       }];
}
@end

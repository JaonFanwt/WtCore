//
//  UIViewController+WtWindowAlert.h
//  FDFullscreenPopGesture
//
//  Created by wtfan on 2017/11/13.
//

#import <UIKit/UIKit.h>

static NSTimeInterval kWtWindowAlertShowAnimationDurationTime = 0.4;

@interface UIViewController (WtWindowAlert)
- (void)wt_showWithCompletion:(void (^)(BOOL finished))completion navigationBarHidden:(BOOL)hidden;
- (void)wt_closeWithCompletion:(void (^)(BOOL finished))completion;
@end

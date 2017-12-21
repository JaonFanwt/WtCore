//
//  UIViewController+WtWindowAlert.h
//  WtUI
//
//  Created by wtfan on 2017/11/13.
//

#import <UIKit/UIKit.h>

static NSTimeInterval kWtWindowAlertShowAnimationDurationTime = 0.4;

@interface UIViewController (WtWindowAlert)
- (void)wtShowWithCompletion:(void (^)(BOOL finished))completion navigationBarHidden:(BOOL)hidden;
- (void)wtCloseWithCompletion:(void (^)(BOOL finished))completion;

- (void)wtCustomShowWithCompletion:(void (^)(BOOL finished))completion navigationBarHidden:(BOOL)hidden;
- (void)wtCustomCloseWithCompletion:(void (^)(BOOL finished))completion;
@end

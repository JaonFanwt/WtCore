//
//  UIViewController+WtWindowAlert.h
//  WtUI
//
//  Created by wtfan on 2017/11/13.
//

#import <UIKit/UIKit.h>

#import "WtWindowAlert.h"

static NSTimeInterval kWtWindowAlertShowAnimationDurationTime = 0.4;

@interface UIViewController (WtWindowAlert)
@property (nonatomic, readonly) WtWindowAlert *wtWindowAlert;

- (void)wtShowWithCompletion:(void (^)(BOOL finished))completion navigationBarHidden:(BOOL)hidden;
- (void)wtCloseWithCompletion:(void (^)(BOOL finished))completion;

- (void)wtCustomShowWithCompletion:(void (^)(BOOL finished))completion navigationBarHidden:(BOOL)hidden;
- (void)wtCustomShowWithBeforeAnimations:(void (^)(void))beforeAnimations WithCompletion:(void (^)(BOOL finished))completion navigationBarHidden:(BOOL)hidden;
- (void)wtCustomCloseWithCompletion:(void (^)(BOOL finished))completion;
@end

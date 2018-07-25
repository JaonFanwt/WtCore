//
//  WtPresentCardViewController.h
//  WtUI
//
//  Created by fanwt on 30/04/2017.
//

#import <UIKit/UIKit.h>


@interface WtPresentCardViewController : UIViewController
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, weak, readonly) UIButton *backgroundView;
@property (nonatomic, copy) void (^wtUserClosed)(void);
#pragma - overwirte
- (UIView *)cardView;
- (void)beforePresentCardView;
- (void)presentCardViewAnimations;
- (void)presentCardViewAnimationsDone;
- (void)beforeDismissCardView;
- (void)dismissCardViewAnimations;
- (void)willClose;
#pragma - public
- (void)show;
- (void)hide;
@end

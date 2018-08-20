//
//  WtWindowAlert.h
//  WtUI
//
//  Created by wtfan on 2017/10/31.
//

#import <UIKit/UIKit.h>


@interface WtWindowAlert : UIView
@property (nonatomic, copy) UIColor *maskingColor; // Default black, alpha:0.3
@property (nonatomic, assign) BOOL isHUD;
@property (nonatomic, assign) BOOL isCard;

- (void)showViewController:(UIViewController *)viewCtrl
       animateWithDuration:(NSTimeInterval)duration
           backgroundColor:(UIColor *)backgroundColor
          beforeAnimations:(void (^)(void))beforeAnimations
                animations:(void (^)(void))animations
                completion:(void (^)(BOOL finished))completion;
- (void)closeAnimateWithDuration:(NSTimeInterval)duration
                      animations:(void (^)(void))animations
                      completion:(void (^)(BOOL finished))completion;
@end

//
//  WtWindowAlert.h
//  KMCGeigerCounter
//
//  Created by wtfan on 2017/10/31.
//

#import <UIKit/UIKit.h>

@interface WtWindowAlert : UIView
-(void)showViewController:(UIViewController*)viewCtrl
      animateWithDuration:(NSTimeInterval)duration
          backgroundColor:(UIColor *)backgroundColor
         beforeAnimations:(void (^)(void))beforeAnimations
               animations:(void (^)(void))animations
               completion:(void (^)(BOOL finished))completion;
-(void)closeAnimateWithDuration:(NSTimeInterval)duration
                     animations:(void (^)(void))animations
                     completion:(void (^)(BOOL finished))completion;
@end

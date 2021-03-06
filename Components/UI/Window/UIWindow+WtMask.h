//
//  UIWindow+WtMask.h
//  WtUIs
//
//  Created by fanwt on 30/04/2017.
//

#import <UIKit/UIKit.h>


@interface UIWindow (WtMask)
@property (nonatomic, readonly) UIView *wtWindowMask;
@property (nonatomic, assign) CGFloat wtMaskAlpha;                    // 0..<1
@property (nonatomic, assign) CGFloat wtMaxMaskAlpha;                 // Default 0.5
@property (nonatomic, assign) NSTimeInterval wtMaskAnimationDuration; // Default 0.25
- (void)wtPrepareMask;
- (void)wtShowMask;
- (void)wtHideMask;
@end

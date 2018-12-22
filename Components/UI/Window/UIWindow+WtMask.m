//
//  UIWindow+WtMask.m
//  WtUI
//
//  Created by fanwt on 30/04/2017.
//

#import "UIWindow+WtMask.h"

@import Masonry;
#import <objc/runtime.h>

#import "WtCore.h"

static NSUInteger kWTWindowMaskBeginTag = 7542;


@interface WtMaskView : UIView

@end


@implementation WtMaskView

@end

#pragma mark -


@implementation UIWindow (WtMask)
- (void)setWTWindowMask:(WtMaskView *)mask {
  objc_setAssociatedObject(self, @selector(WTWindowMask), mask, OBJC_ASSOCIATION_ASSIGN);
}

- (WtMaskView *)WTWindowMask {
  return objc_getAssociatedObject(self, @selector(WTWindowMask));
}

- (WtMaskView *)wtWindowMask {
  return [self WTWindowMask];
}

- (NSTimeInterval)wtMaskAnimationDuration {
  id t = objc_getAssociatedObject(self, @selector(wtMaskAnimationDuration));
  if (!t) {
    self.wtMaskAnimationDuration = .25;
  }
  return [t doubleValue];
}

- (void)setWtMaskAnimationDuration:(NSTimeInterval)wtMaskAnimationDuration {
  objc_setAssociatedObject(self, @selector(wtMaskAnimationDuration), @(wtMaskAnimationDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wtPrepareMask {
  WtMaskView *mask = [self WTWindowMask]; // 先看是否有引用
  if (mask == nil) {
    NSUInteger tag = kWTWindowMaskBeginTag;
    while (true) {
      tag++;
      UIView *v = [self viewWithTag:tag];
      if (!v) {
        mask = [[WtMaskView alloc] init];
        mask.tag = tag;
        [self addSubview:mask];
        [mask mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.top.right.equalTo(self);
          make.height.mas_equalTo(self.frame.size.height);
        }];
        break;
      } else if ([v isKindOfClass:[WtMaskView class]]) {
        mask = (WtMaskView *)v;
        break;
      }
    }
    [self setWTWindowMask:mask];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.5;
    mask.hidden = YES;
    mask.userInteractionEnabled = NO;
  }
}

- (void)wtShowMask {
  WtMaskView *windowMask = [self WTWindowMask];

  windowMask.alpha = 0;
  windowMask.hidden = NO;
  NSNumber *alpha = [self WTMaskAlpha];
  CGFloat alphaFloat = 0.5;
  if (alpha == nil) {
    [self setWTMaskAlpha:alphaFloat];
  } else {
    alphaFloat = [alpha floatValue];
  }
  if (alphaFloat > self.wtMaxMaskAlpha) {
    alphaFloat = self.wtMaxMaskAlpha;
  }

  if (windowMask) {
    self.window.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.35 animations:^{
      windowMask.alpha = alphaFloat;
    } completion:^(BOOL finished) {
      self.window.userInteractionEnabled = YES;
    }];
  }
}

- (void)wtHideMask {
  WtMaskView *windowMask = [self WTWindowMask];
  if (windowMask) {
    self.window.userInteractionEnabled = NO;
    [UIView animateWithDuration:self.wtMaskAnimationDuration animations:^{
      windowMask.alpha = 0.0;
    } completion:^(BOOL finished) {
      windowMask.hidden = YES;
      [windowMask removeFromSuperview];
      [self setWTWindowMask:nil];
    }];
  }
}

#pragma mark - Statusbar
- (UIView *)wtAppleStatusBar {
  UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
  if ([statusBar isKindOfClass:[UIView class]]) {
    return statusBar.superview;
  }
  return nil;
}

#pragma mark - wtMaskAlpha
- (void)setWTMaskAlpha:(CGFloat)wtMaskAlpha {
  objc_setAssociatedObject(self, @selector(WTMaskAlpha), @(wtMaskAlpha), OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)WTMaskAlpha {
  return objc_getAssociatedObject(self, @selector(WTMaskAlpha));
}

- (void)setWtMaskAlpha:(CGFloat)wtMaskAlpha {
  WtMaskView *windowMask = [self WTWindowMask];
  windowMask.alpha = wtMaskAlpha;

  [self setWTMaskAlpha:wtMaskAlpha];
}

- (CGFloat)wtMaskAlpha {
  return [[self WTMaskAlpha] floatValue];
}

#pragma mark - wtMaxMaskAlpha
- (void)setWTMaxMaskAlpha:(CGFloat)wtMaxMaskAlpha {
  objc_setAssociatedObject(self, @selector(WTMaxMaskAlpha), @(wtMaxMaskAlpha), OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)WTMaxMaskAlpha {
  return objc_getAssociatedObject(self, @selector(WTMaxMaskAlpha));
}

- (void)setWtMaxMaskAlpha:(CGFloat)wtMaxMaskAlpha {
  [self setWTMaxMaskAlpha:wtMaxMaskAlpha];
}

- (CGFloat)wtMaxMaskAlpha {
  NSNumber *alpha = [self WTMaxMaskAlpha];
  if (alpha == nil) {
    return 0.5;
  }

  return [[self WTMaxMaskAlpha] floatValue];
}

@end

//
//  UIWindow+WtMask.m
//  WtUI
//
//  Created by fanwt on 30/04/2017.
//

#import "UIWindow+WtMask.h"

@import Masonry;
@import ReactiveCocoa;
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

- (void)wtPrepareMask {
    UIView *statusBar = [self wtAppleStatusBar];
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
                    make.left.right.bottom.equalTo(self);
                    make.top.equalTo(self.mas_top).offset(statusBar.frame.size.height);
                }];
                
                @weakify(mask, statusBar);
                [[RACObserve(statusBar, alpha) takeUntil:[v rac_willDeallocSignal]] subscribeNext:^(id x) {
                    @strongify(mask, statusBar);
                    CGFloat statusBarHeight = statusBar.hidden?0:statusBar.frame.size.height;
                    [mask mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.mas_top).offset(statusBarHeight);
                    }];
                    [self setNeedsUpdateConstraints];
                    [self layoutIfNeeded];
                }];
                
                break;
            }else if ([v isKindOfClass:[WtMaskView class]]){
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
    
    [self wtPrepareStatusBarMask];
}

- (void)wtShowMask {
    WtMaskView *windowMask = [self WTWindowMask];
    WtMaskView *statusBarMask = [self WTStatusBarMask];
    
    UIView *statusBar = [self wtAppleStatusBar];
    CGFloat statusBarHeight = statusBar.isHidden?0:statusBar.frame.size.height;
    [windowMask mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(statusBarHeight);
    }];
    
    windowMask.alpha = 0;
    windowMask.hidden = NO;
    statusBarMask.alpha = 0;
    statusBarMask.hidden = NO;
    NSNumber *alpha = [self WTMaskAlpha];
    CGFloat alphaFloat = 0.5;
    if (alpha == nil) {
        [self setWTMaskAlpha:alphaFloat];
    }else {
        alphaFloat = [alpha floatValue];
    }
    if (alphaFloat > self.wtMaxMaskAlpha) {
        alphaFloat = self.wtMaxMaskAlpha;
    }
    
    if (windowMask && statusBarMask) {
        self.window.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.35 animations:^{
            windowMask.alpha = alphaFloat;
            statusBarMask.alpha = alphaFloat;
        } completion:^(BOOL finished) {
            self.window.userInteractionEnabled = YES;
        }];
    }
}

- (void)wtHideMask {
    WtMaskView *windowMask = [self WTWindowMask];
    WtMaskView *statusBarMask = [self WTStatusBarMask];
    if (windowMask && statusBarMask) {
        self.window.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.35 animations:^{
            windowMask.alpha = 0.0;
            statusBarMask.alpha = 0.0;
        } completion:^(BOOL finished) {
            windowMask.hidden = YES;
            statusBarMask.hidden = YES;
            self.window.userInteractionEnabled = YES;
        }];
    }
}

#pragma mark - Statusbar
- (void)setWTStatusBarMask:(WtMaskView *)mask {
    objc_setAssociatedObject(self, @selector(WTStatusBarMask), mask, OBJC_ASSOCIATION_ASSIGN);
}

- (WtMaskView *)WTStatusBarMask {
    return objc_getAssociatedObject(self, @selector(WTStatusBarMask));
}

- (UIView *)wtStatusBarMask {
    return [self WTStatusBarMask];
}

- (UIView *)wtAppleStatusBar {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar isKindOfClass:[UIView class]]) {
        return statusBar;
    }
    return nil;
}

- (void)wtPrepareStatusBarMask {
    UIView *statusBar = [self wtAppleStatusBar];
    WtMaskView *mask = [self WTStatusBarMask]; // 先看是否有引用
    if (mask == nil) {
        NSUInteger tag = kWTWindowMaskBeginTag;
        while (true) {
            tag++;
            UIView *v = [statusBar viewWithTag:tag];
            if (!v) {
                mask = [[WtMaskView alloc] init];
                mask.tag = tag;
                [statusBar addSubview:mask];
                [mask mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.right.bottom.equalTo(statusBar);
                }];
                break;
            }else if ([v isKindOfClass:[WtMaskView class]]){
                mask = (WtMaskView *)v;
                break;
            }
        }
        [self setWTStatusBarMask:mask];
        mask.backgroundColor = [UIColor blackColor];
        mask.alpha = 0.5;
        mask.hidden = YES;
        mask.userInteractionEnabled = NO;
    }
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
    WtMaskView *statusBarMask = [self WTStatusBarMask];
    windowMask.alpha = wtMaskAlpha;
    statusBarMask.alpha = wtMaskAlpha;
    
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

//
//  WtWindowAlert.m
//  WtUI
//
//  Created by wtfan on 2017/10/31.
//

#import "WtWindowAlert.h"

#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

#import "WtWindow.h"
#import "WtWindowRootViewController.h"
#import "UIWindow+WtWindow.h"

#ifndef wtWindowLevel
#define wtWindowLevel UIWindowLevelNormal + 1
#endif
#ifndef wtHUDWindowLevel
#define wtHUDWindowLevel UIWindowLevelAlert + 1
#endif

static int kWtWindowAlertNum = 0;


@interface WtWindowAlert ()
@property (nonatomic, strong) WtWindow *window;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) WtWindowRootViewController *modalViewCtrl;
@property (nonatomic, assign) int windowLevelGrowNum;
@end


@implementation WtWindowAlert
- (void)dealloc {
  --kWtWindowAlertNum;
}

- (instancetype)init {
  if (self = [super init]) {
    self.windowLevelGrowNum = ++kWtWindowAlertNum;
    WtWindow *window = [[WtWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowAlert = self;
    window.backgroundColor = [UIColor clearColor];
    window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    window.opaque = NO;
    window.windowLevel = wtWindowLevel + self.windowLevelGrowNum;
    self.window = window;

    self.frame = window.frame;
    self.backgroundColor = [UIColor clearColor];

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    _containerView = containerView;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
      UIViewAutoresizingFlexibleWidth |
      UIViewAutoresizingFlexibleRightMargin |
      UIViewAutoresizingFlexibleTopMargin |
      UIViewAutoresizingFlexibleHeight |
      UIViewAutoresizingFlexibleBottomMargin;
    containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:containerView];
    containerView.center = window.center;

    WtWindowRootViewController *modalViewCtrl = [[WtWindowRootViewController alloc] initWithNibName:nil bundle:nil];
    modalViewCtrl.view.backgroundColor = [UIColor clearColor];
    modalViewCtrl.wrapView = self;
    self.window.rootViewController = modalViewCtrl;
  }
  return self;
}

- (void)setIsHUD:(BOOL)isHUD {
  _isHUD = isHUD;

  self.window.windowLevel = _isHUD ? (wtHUDWindowLevel + self.windowLevelGrowNum) : (wtWindowLevel + self.windowLevelGrowNum);
  self.window.userInteractionEnabled = !isHUD;
}

- (void)viewController:(UIViewController *)viewCtrl viewWillAppear:(BOOL)animation {
  if (_isHUD) return;
  if (_isCard) return;
  if ([viewCtrl isKindOfClass:[UINavigationController class]]) {
    [[(UINavigationController *)viewCtrl topViewController] viewWillAppear:animation];
  } else {
    [viewCtrl viewWillAppear:animation];
  }
}

- (void)viewController:(UIViewController *)viewCtrl viewDidAppear:(BOOL)animation {
  if (_isHUD) return;
  if (_isCard) return;
  if ([viewCtrl isKindOfClass:[UINavigationController class]]) {
    [[(UINavigationController *)viewCtrl topViewController] viewDidAppear:animation];
  } else {
    [viewCtrl viewDidAppear:animation];
  }
}

- (void)viewController:(UIViewController *)viewCtrl viewWillDisAppear:(BOOL)animation {
  if (_isHUD) return;
  if (_isCard) return;
  if ([viewCtrl isKindOfClass:[UINavigationController class]]) {
    [[(UINavigationController *)viewCtrl topViewController] viewWillDisappear:animation];
  } else {
    [viewCtrl viewWillDisappear:animation];
  }
}

- (void)viewController:(UIViewController *)viewCtrl viewDidDisAppear:(BOOL)animation {
  if (_isHUD) return;
  if (_isCard) return;
  if ([viewCtrl isKindOfClass:[UINavigationController class]]) {
    [[(UINavigationController *)viewCtrl topViewController] viewDidDisappear:animation];
  } else {
    [viewCtrl viewDidDisappear:animation];
  }
}

- (void)showViewController:(UIViewController *)viewCtrl
       animateWithDuration:(NSTimeInterval)duration
           backgroundColor:(UIColor *)backgroundColor
          beforeAnimations:(void (^)(void))beforeAnimations
                animations:(void (^)(void))animations
                completion:(void (^)(BOOL finished))completion {
  if (!viewCtrl) return;
  if (!_isHUD && ![viewCtrl isKindOfClass:[UINavigationController class]] && !viewCtrl.navigationController) {
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:viewCtrl];
    viewCtrl.fd_prefersNavigationBarHidden = YES;
    self.window.rootViewController = navCtrl;
  } else {
    self.window.rootViewController = viewCtrl;
  }
  [self.window setHidden:NO];
  if (!_isHUD) [self.window makeKeyAndVisible];

  if (!_maskingColor) {
    _maskingColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
  }

  if (beforeAnimations) {
    beforeAnimations();
  }

  UIViewController *preViewCtrl = nil;
  if (!_isHUD) {
    UIWindow *window = [self.window wtPreWindow];
    preViewCtrl = [window wtTopViewController];
    if (preViewCtrl && !_isCard) {
      [self viewController:preViewCtrl viewWillDisAppear:YES];
    }

    // 添加背景色
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [viewCtrl.view insertSubview:backgroundView atIndex:0];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [viewCtrl.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewCtrl.view
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:3
                                                               constant:0]];
    [viewCtrl.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewCtrl.view
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:3
                                                               constant:0]];
    [viewCtrl.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewCtrl.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0]];
    [viewCtrl.view addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:viewCtrl.view
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1
                                                               constant:0]];
    _backgroundView = backgroundView;
  }

  viewCtrl.view.userInteractionEnabled = NO;
  [UIView animateWithDuration:duration
    delay:0
    usingSpringWithDamping:1.0
    initialSpringVelocity:1.0
    options:UIViewAnimationOptionCurveEaseInOut
    animations:^{
      self.backgroundView.backgroundColor = self.maskingColor;
      if (animations) {
        animations();
      }
    }
    completion:^(BOOL finished) {
      if (completion) {
        completion(YES);
      }
    
      if (preViewCtrl && !_isCard) {
        [self viewController:preViewCtrl viewDidDisAppear:YES];
      }
      
      viewCtrl.view.userInteractionEnabled = YES;
    }];
}

- (void)closeAnimateWithDuration:(NSTimeInterval)duration
                      animations:(void (^)(void))animations
                      completion:(void (^)(BOOL finished))completion {
  UIViewController *viewCtrl = nil;
  if (!_isHUD) {
    UIWindow *window = [self.window wtPreWindow];
    viewCtrl = [window wtTopViewController];

    if (viewCtrl && !_isCard) {
      [self viewController:viewCtrl viewWillAppear:YES];
    }
    [window makeKeyWindow];

    viewCtrl.view.userInteractionEnabled = NO;
    _window.userInteractionEnabled = NO;
  }

  UIColor *maskingColor = [self.maskingColor colorWithAlphaComponent:0];

  [UIView animateWithDuration:duration
    delay:0
    usingSpringWithDamping:1.0
    initialSpringVelocity:1.0
    options:UIViewAnimationOptionCurveEaseInOut
    animations:^{
      self.backgroundView.backgroundColor = maskingColor;
      if (animations) {
        animations();
      }
    }
    completion:^(BOOL finished) {
      self.window.hidden = YES;
      if (completion) {
        completion(finished);
      }
      self.window = nil;
      [self viewController:viewCtrl viewDidAppear:YES];
      viewCtrl.view.userInteractionEnabled = YES;
    }];
}
@end

//
//  WtPresentCardViewController.m
//  WtUI
//
//  Created by fanwt on 30/04/2017.
//

#import "WtPresentCardViewController.h"

@import Masonry;

#import "WtCore.h"
#import "UIControl+WtUI.h"
#import "WtWindow.h"
#import "UIViewController+WtWindowAlert.h"


@interface WtPresentCardViewController ()
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, assign) BOOL isPresentedCardView;
@end


@implementation WtPresentCardViewController

- (void)loadView {
  [super loadView];

  _animationDuration = .25;

  UIButton *backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.view addSubview:backgroundView];
  _backgroundView = backgroundView;
  [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.top.equalTo(self.view);
  }];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  [self presentCardView];
}

- (UIView *)cardView {
  return nil;
}

- (void)beforePresentCardView {
}

- (void)presentCardViewAnimations {
}

- (void)presentCardViewAnimationsDone {
}

- (void)beforeDismissCardView {
}

- (void)dismissCardViewAnimations {
}

- (void)willClose {
}

- (void)presentCardView {
  if (self.isPresentedCardView) return;
  self.isPresentedCardView = YES;

  self.cardView = [self cardView];
  [self beforePresentCardView];

  [UIView animateWithDuration:_animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    [self presentCardViewAnimations];
  } completion:^(BOOL finished){
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self bindActions];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.view sendSubviewToBack:_backgroundView];
}

- (void)bindActions {
  @weakify(self);
  [self.backgroundView wtAction:^(UIControl *control, UIControlEvents controlEvents) {
    @strongify(self);
    [self hide];
    if (self.wtUserClosed) {
      self.wtUserClosed();
    }
  } forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Public
- (void)show {
  @weakify(self);
  self.wtWindowAlert.isCard = YES;
  [self wtCustomShowWithBeforeAnimations:^{
    @strongify(self);
    self.backgroundView.backgroundColor = [UIColor wtColorWithHTMLName:@"#222222 0.1"];
    self.backgroundView.alpha = 0.;
  } WithCompletion:^(BOOL finished) {
    @strongify(self);
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      self.backgroundView.alpha = 1.;
    } completion:^(BOOL finished) {
      [self presentCardViewAnimationsDone];
    }];
  } navigationBarHidden:YES];
}

- (void)hide {
  [self willClose];
  [self beforeDismissCardView];

  [UIView animateWithDuration:_animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    [self dismissCardViewAnimations];
    self.backgroundView.alpha = 0.;
  } completion:^(BOOL finished) {
    [self wtCustomCloseWithCompletion:^(BOOL finished){
    }];
  }];
}
@end

//
//  WtWindowRootViewController.m
//  WtUI
//
//  Created by wtfan on 2017/10/31.
//

#import "WtWindowRootViewController.h"


@implementation WtWindowRootViewController
- (void)dealloc {
#ifdef DEBUG
  NSLog(@"%s", __func__);
#endif
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view = _wrapView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return [UIApplication sharedApplication].statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
  return [UIApplication sharedApplication].statusBarHidden;
}
@end

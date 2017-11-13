//
//  WtWindowRootViewController.m
//  KMCGeigerCounter
//
//  Created by wtfan on 2017/10/31.
//

#import "WtWindowRootViewController.h"

@implementation WtWindowRootViewController
- (void)dealloc {
    NSLog(@"%s", __func__);
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

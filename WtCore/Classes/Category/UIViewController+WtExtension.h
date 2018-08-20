//
//  UIViewController+WtExtension.h
//  WtCore
//
//  Created by wtfan on 2018/1/2.
//

#import <UIKit/UIKit.h>


@interface UIViewController (WtExtension)
- (UIViewController *)wtPreviousViewController;
- (void)wtPushViewController:(UIViewController *)toViewCtrl animated:(BOOL)animated getRidNum:(NSUInteger)getRidNum;
@end

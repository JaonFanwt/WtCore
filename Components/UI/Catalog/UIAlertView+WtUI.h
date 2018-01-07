//
//  UIAlertView+WtUI.h
//  WtUI
//
//  Created by wtfan on 2017/9/8.
//
//

#import <UIKit/UIKit.h>

#import "WtDelegateProxy.h"

@interface UIAlertView (WtUI)
@property (nonatomic, strong, readonly) WtDelegateProxy<UIAlertViewDelegate> *wtDelegateProxy;
@end

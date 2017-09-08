//
//  UIAlertView+WtExtension.h
//  Pods
//
//  Created by wtfan on 2017/9/8.
//
//

#import <UIKit/UIKit.h>

#import "WtDelegateProxy.h"

@interface UIAlertView (WtExtension)
@property (nonatomic, strong, readonly) WtDelegateProxy<UIAlertViewDelegate> *wtDelegateProxy;
@end

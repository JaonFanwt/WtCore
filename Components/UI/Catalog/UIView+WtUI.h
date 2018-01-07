//
//  UIView+WtUI.h
//  WtCore
//
//  Created by wtfan on 2018/1/7.
//

#import <UIKit/UIKit.h>

#import "WtDelegateProxy.h"

@interface UIView (WtUI)
- (void)wtWhenTapped:(void (^)(void))block;
@end

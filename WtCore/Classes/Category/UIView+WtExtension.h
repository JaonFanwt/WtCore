//
//  UIView+WtExtension.h
//  WtCore
//
//  Created by wtfan on 2017/9/12.
//
//

#import <Foundation/Foundation.h>

@interface UIView (WtExtension)
- (UIViewController *)wtFirstViewController;
- (UIView *)wtFirstSuperViewWithClass:(Class)cls;
- (UIView *)wtFirstSubViewWithClass:(Class)cls;
@end

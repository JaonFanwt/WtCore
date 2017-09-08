//
//  UIControl+WtExtension.h
//  Pods
//
//  Created by wtfan on 2017/9/8.
//
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"

@protocol WtControlProtocol <NSObject>
- (void)wtAction:(UIControl *)control controlEvents:(UIControlEvents)controlEvents;
@end

@interface UIControl (WtExtension)
- (void)wtAction:(void (^)(UIControl *control, UIControlEvents controlEvents))block forControlEvents:(UIControlEvents)event;
@end

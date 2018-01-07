//
//  UIActionSheet+WtUI.h
//  WtUI
//
//  Created by wtfan on 2017/9/8.
//
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"

@interface UIActionSheet (WtUI)
@property (nonatomic, strong, readonly) WtDelegateProxy<UIActionSheetDelegate> *wtDelegateProxy;
@end

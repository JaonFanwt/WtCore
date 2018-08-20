//
//  WtViewGlue.h
//  WtUI
//
//  Created by wtfan on 2017/9/11.
//
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"


@interface WtViewGlue : NSObject
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
@property (nonatomic, strong, readonly) WtDelegateProxy<UIViewControllerPreviewingDelegate> *previewingDelegate;
#else
@property (nonatomic, strong, readonly) WtDelegateProxy *previewingDelegate; // iOS9以下为nil
#endif
@end

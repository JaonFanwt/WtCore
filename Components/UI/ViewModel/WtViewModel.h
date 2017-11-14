//
//  WtViewModel.h
//  WtUI
//
//  Created by wtfan on 2017/9/11.
//
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"

@interface WtViewModel : NSObject
@property (nonatomic, strong, readonly) WtDelegateProxy<UIViewControllerPreviewingDelegate> *previewingDelegate;
@end

//
//  WtViewModel.h
//  Pods
//
//  Created by wtfan on 2017/9/11.
//
//

#import <Foundation/Foundation.h>

#import <WtCore/WtDelegateProxy.h>

@interface WtViewModel : NSObject
@property (nonatomic, strong, readonly) WtDelegateProxy<UIViewControllerPreviewingDelegate> *previewingDelegate;
@end

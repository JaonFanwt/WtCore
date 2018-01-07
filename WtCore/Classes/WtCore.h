//
//  WtCore.h
//  WtCore
//
//  Created by wtfan on 2017/8/30.
//
//

#import <Foundation/Foundation.h>

@import ReactiveCocoa;

#ifdef RACObserve
#undef RACObserve
#define RACObserve(TARGET, KEYPATH) \
    ({ \
        __weak id target_ = (TARGET); \
        [target_ rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]; \
    })
#endif

#import "NSString+WtEncrypt.h"
#import "NSString+WtExtension.h"
#import "NSURL+WtExtension.h"
#import "UIDevice+WtExtension.h"
#import "UIView+WtExtension.h"
#import "UIColor+WtExtension.h"
#import "UIViewController+WtExtension.h"

#import "WtSwizzle.h"
#import "WtDispatch.h"
#import "WtDelegateProxy.h"

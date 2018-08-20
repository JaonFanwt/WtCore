//
//  WtURLSessionManagerTaskDelegate.h
//  WtThunderWeb
//
//  Created by wtfan on 2017/9/12.
//
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"


@interface WtURLSessionManagerTaskDelegate : NSObject
@property (nonatomic, strong) WtDelegateProxy<NSURLSessionDelegate> *sessionDelegate;
@property (nonatomic, strong) WtDelegateProxy<NSURLSessionDataDelegate> *sessionDataDelegate;
@property (nonatomic, strong) WtDelegateProxy<NSURLSessionTaskDelegate> *sessionTaskDelegate;
@end

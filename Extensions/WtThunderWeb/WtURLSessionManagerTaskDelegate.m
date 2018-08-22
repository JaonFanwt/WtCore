//
//  WtURLSessionManagerTaskDelegate.m
//  WtThunderWeb
//
//  Created by wtfan on 2017/9/12.
//
//

#import "WtURLSessionManagerTaskDelegate.h"


@implementation WtURLSessionManagerTaskDelegate
- (void)dealloc {
#ifdef DEBUG
  NSLog(@"%s", __func__);
#endif
}

- (instancetype)init {
  if (self = [super init]) {
    _sessionDelegate = (WtDelegateProxy<NSURLSessionDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(NSURLSessionDelegate)];
    _sessionDataDelegate = (WtDelegateProxy<NSURLSessionDataDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(NSURLSessionDataDelegate)];
    _sessionTaskDelegate = (WtDelegateProxy<NSURLSessionTaskDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(NSURLSessionTaskDelegate)];
  }
  return self;
}
@end

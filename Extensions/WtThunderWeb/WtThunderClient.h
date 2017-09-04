//
//  WtThunderClient.h
//  Pods
//
//  Created by wtfan on 2017/8/29.
//
//

#import <Foundation/Foundation.h>

#import <WtCore/WtDelegateProxy.h>

#import "WtThunderSession.h"

NSURLRequest *wtThunderWrapWebRequest(NSURLRequest *request, NSString *userIdentifier);

@interface WtThunderClient : NSObject
@property (nonatomic, assign) NSTimeInterval cacheControlMaxAge; // Default 10s
+ (instancetype)shared;
- (void)createSessionWithUrlString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier delegateProxy:(WtDelegateProxy<WtThunderSessionDelegate> *)proxy;
- (BOOL)isExistSessionWithUrlString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier;
@end

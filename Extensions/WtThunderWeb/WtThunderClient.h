//
//  WtThunderClient.h
//  WtThunderWeb
//
//  Created by wtfan on 2017/8/29.
//
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"

#import "WtThunderSession.h"

NSURLRequest *wtThunderProduceWebRequest(NSURLRequest *request, NSString *userIdentifier);
NSURLRequest *wtThunderConsumeWebRequest(NSURLRequest *request, NSString *userIdentifier);

@interface WtThunderClient : NSObject
@property (nonatomic, assign) NSTimeInterval cacheControlMaxAge; // Default 10s
+ (instancetype)shared;
- (void)createSessionWithUrlString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier delegateProxy:(WtDelegateProxy<WtThunderSessionDelegate> *)proxy;
- (void)consumeSessionWithUrlString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier delegateProxy:(WtDelegateProxy<WtThunderSessionDelegate> *)proxy;
- (BOOL)isExistSessionWithUrlString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier;
@end

//
//  WtThunderURLProtocol.m
//  WtThunderWeb
//
//  Created by wtfan on 2017/8/29.
//
//

#import "WtThunderURLProtocol.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtObserver.h"
#import "WtDispatch.h"

#import "WtThunderClient.h"
#import "WtThunderConstants.h"


typedef NS_ENUM(NSUInteger, eWtThunderURLProtocolActionType) {
    eWtThunderURLProtocolActionTypeDidRecieveResponse = 1,
    eWtThunderURLProtocolActionTypeDidLoadData,
    eWtThunderURLProtocolActionTypeDidFaild,
    eWtThunderURLProtocolActionTypeDidFinish
};

static NSString *kWtThunderURLProtocolActionKey = @"kWtThunderURLProtocolAction";
static NSString *kWtThunderProtocolDataKey = @"kWtThunderProtocolDataKey";

@interface WtThunderURLProtocol ()
@property (nonatomic, assign) BOOL didFinishRecvResponse;
@property (nonatomic, assign) long long recvDataLength;
@end

@implementation WtThunderURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (!([request.URL.scheme isEqualToString:@"http"] ||
        [request.URL.scheme isEqualToString:@"https"])) {
        return NO;
    }
    
    NSString *value = [request valueForHTTPHeaderField:WtThunderHeaderKeyLoadType];
    
    if (value && [value isEqualToString:WtThunderHeaderValueRemoteLoad]) {
        return NO;
    }else if ((value && ([value isEqualToString:WtThunderHeaderValueProduceLoad] || [value isEqualToString:WtThunderHeaderValueConsumeLoad])) ||
              ([[WtThunderClient shared] isExistSessionWithUrlString:request.URL.absoluteString userIdentifier:@""])) {
        NSLog(@"[Pre load request]: %@", request.URL.absoluteString);
        
        wtDispatch_in_main(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:WtThunderCanInitWithRequestURLNotification object:[NSString stringWithFormat:@"%@", request.URL.absoluteString]];
        });
        
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSThread *currentThread = [NSThread currentThread];
    
    NSString *userIdentifier = [self.request valueForHTTPHeaderField:WtThunderHeaderKeySessionUserIdentifier];
    NSString *loadType = [self.request valueForHTTPHeaderField:WtThunderHeaderKeyLoadType];
    
    BOOL isConsumer = YES;
    if (loadType && [loadType isEqualToString:WtThunderHeaderValueProduceLoad]) {
        isConsumer = NO;
    }else {}
    
    WtDelegateProxy<WtThunderSessionDelegate> *proxy = (WtDelegateProxy<WtThunderSessionDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(WtThunderSessionDelegate)];
    @weakify(self, currentThread);
    [proxy selector:@selector(session:didRecieveResponse:) block:^(WtThunderSession *session, NSHTTPURLResponse *response){
        @strongify(self, currentThread);
        NSMutableDictionary *params = @{kWtThunderURLProtocolActionKey: @(eWtThunderURLProtocolActionTypeDidRecieveResponse)}.mutableCopy;
        if (response) {
            [params setObject:response forKey:kWtThunderProtocolDataKey];
        }
        [self performSelector:@selector(handlerSessionDelegateWithParams:) onThread:currentThread withObject:params waitUntilDone:NO];
    }];
    
    [proxy selector:@selector(session:didLoadData:) block:^(WtThunderSession *session, NSData *data){
        @strongify(self, currentThread);
        NSMutableDictionary *params = @{kWtThunderURLProtocolActionKey: @(eWtThunderURLProtocolActionTypeDidLoadData)}.mutableCopy;
        if (data) {
            [params setObject:data forKey:kWtThunderProtocolDataKey];
        }
        [self performSelector:@selector(handlerSessionDelegateWithParams:) onThread:currentThread withObject:params waitUntilDone:NO];
    }];
    
    [proxy selector:@selector(session:didFaild:) block:^(WtThunderSession *session, NSError *error){
        @strongify(self, currentThread);
        NSMutableDictionary *params = @{kWtThunderURLProtocolActionKey: @(eWtThunderURLProtocolActionTypeDidFaild)}.mutableCopy;
        if (error) {
            [params setObject:error forKey:kWtThunderProtocolDataKey];
        }
        [self performSelector:@selector(handlerSessionDelegateWithParams:) onThread:currentThread withObject:params waitUntilDone:NO];
    }];
    
    [proxy selector:@selector(sessionDidFinish:) block:^(WtThunderSession *session){
        @strongify(self, currentThread);
        NSMutableDictionary *params = @{kWtThunderURLProtocolActionKey: @(eWtThunderURLProtocolActionTypeDidFinish)}.mutableCopy;
        if (session) {
            [params setObject:session forKey:kWtThunderProtocolDataKey];
        }
        [self performSelector:@selector(handlerSessionDelegateWithParams:) onThread:currentThread withObject:params waitUntilDone:NO];
    }];
    
    if (isConsumer) {
        [[WtThunderClient shared] consumeSessionWithUrlString:self.request.URL.absoluteString userIdentifier:userIdentifier delegateProxy:proxy];
    }else {
        [[WtThunderClient shared] createSessionWithUrlString:self.request.URL.absoluteString userIdentifier:userIdentifier delegateProxy:proxy];
    }
}

- (void)stopLoading {
    
}

- (void)handlerSessionDelegateWithParams:(NSDictionary *)params {
    eWtThunderURLProtocolActionType action = [params[kWtThunderURLProtocolActionKey] integerValue];
    if (action == eWtThunderURLProtocolActionTypeDidRecieveResponse) {
        NSHTTPURLResponse *response = params[kWtThunderProtocolDataKey];
        if (response && !_didFinishRecvResponse) {
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            _didFinishRecvResponse = YES;
        }
    }else if (action == eWtThunderURLProtocolActionTypeDidLoadData) {
        if (_didFinishRecvResponse) {
            NSData *data = params[kWtThunderProtocolDataKey];
            if (data.length > 0) {
                [self.client URLProtocol:self didLoadData:data];
                self.recvDataLength += data.length;
            }
        }
    }else if (action == eWtThunderURLProtocolActionTypeDidFaild) {
        NSError *error = params[kWtThunderProtocolDataKey];
        if (error) {
            [self.client URLProtocol:self didFailWithError:error];
        }else {
            error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
            [self.client URLProtocol:self didFailWithError:error];
        }
    }else if (action == eWtThunderURLProtocolActionTypeDidFinish) {
        [self.client URLProtocolDidFinishLoading:self];
    }else {}
}
@end

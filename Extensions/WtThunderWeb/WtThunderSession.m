//
//  WtThunderSession.m
//  Pods
//
//  Created by wtfan on 2017/8/29.
//
//

#import "WtThunderSession.h"

#import <WtCore/WtCore.h>
#import <WtCore/WtDispatch.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtThunderQueueManager.h"

NSString *thunderSessionID(NSString *urlString, NSString *userIdentifier) {
    if (userIdentifier && userIdentifier.length > 0) {
        return wtStringFromMD5([NSString stringWithFormat:@"%@_%@", urlString, userIdentifier]);
    }else {
        return wtStringFromMD5([NSString stringWithFormat:@"%@", urlString]);
    }
}

@interface WtThunderSession ()
<NSURLSessionDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;

@property (nonatomic, assign) NSTimeInterval sessionDidFinishTime;
@end

@implementation WtThunderSession
- (instancetype)initWithURLString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier {
    if (self = [super init]) {
        _urlString = urlString;
        _request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        _sessionID = thunderSessionID(urlString, userIdentifier);
    }
    return self;
}

- (void)start {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[WtThunderQueueManager connectionQueue]];
    _sessionTask = [_session dataTaskWithRequest:_request];
    [_sessionTask resume];
}

- (void)cancel {
    if (_sessionTask && _sessionTask.state == NSURLSessionTaskStateRunning) {
        [_sessionTask cancel];
        [_session finishTasksAndInvalidate];
    }else {
        [_session invalidateAndCancel];
    }
}

- (BOOL)isExpiredWithMaxAge:(NSTimeInterval)maxAge {
    return [[NSDate date] timeIntervalSince1970] > _sessionDidFinishTime + maxAge;
}

#pragma mark - private
- (void)session:(NSURLSession *)session didRecieveResponse:(NSHTTPURLResponse *)response {
    _response = response;
    if (_delegate && [_delegate respondsToSelector:@selector(session:didRecieveResponse:)]) {
        [self.delegate session:self didRecieveResponse:response];
    }
}

- (void)session:(NSURLSession *)session didLoadData:(NSData *)date {
    if (_delegate && [_delegate respondsToSelector:@selector(session:didLoadData:)]) {
        [self.delegate session:self didLoadData:date];
    }
}

- (void)session:(NSURLSession *)session didFaild:(NSError *)error {
    if (error) {
        _error = error;
        _isCompletion = YES;
        
        if (_delegate && [_delegate respondsToSelector:@selector(session:didFaild:)]) {
            [self.delegate session:self didFaild:error];
        }
    }else {}
}

- (void)sessionDidFinish:(NSURLSession *)session {
    _isCompletion = YES;
    _sessionDidFinishTime = [[NSDate date] timeIntervalSince1970];
    
    if (_delegate && [_delegate respondsToSelector:@selector(sessionDidFinish:)]) {
        [self.delegate sessionDidFinish:self];
    }
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    [self session:session didFaild:error];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
    [self session:session didRecieveResponse:(NSHTTPURLResponse *)response];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    if (!_responseData) {
        _responseData = [NSMutableData data];
    }
    
    if (data) {
        [_responseData appendData:[data copy]];
    }
    
    [self session:session didLoadData:data];
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    completionHandler(request);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        [self session:session didFaild:error];
    }else {
        [self sessionDidFinish:session];
    }
}

@end

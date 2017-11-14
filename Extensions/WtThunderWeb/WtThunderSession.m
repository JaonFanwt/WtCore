//
//  WtThunderSession.m
//  WtThunderWeb
//
//  Created by wtfan on 2017/8/29.
//
//

#import "WtThunderSession.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtCore.h"
#import "WtDispatch.h"

#import "WtThunderQueueManager.h"
#import "WtThunderConstants.h"
#import "WtThunderURLSessionManager.h"

NSString *wtThunderSessionID(NSString *urlString, NSString *userIdentifier) {
    NSURL *url = [[NSURL URLWithString:urlString] wtSortedByCompareQueryComponents];
    if (url) {
        urlString = url.absoluteString;
    }
    
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

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, assign) NSTimeInterval sessionDidFinishTime;

@property (nonatomic, strong) WtURLSessionManagerTaskDelegate *taskDelegate;
@end

@implementation WtThunderSession
- (void)dealloc {
    NSLog(@"%s", __func__);
    [self cancel];
}

- (instancetype)initWithURLString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier {
    if (self = [super init]) {
        _beginTime = [[NSDate date] timeIntervalSince1970];
        _urlString = urlString;
        _request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        _request.timeoutInterval = 20.0;
        [_request setValue:WtThunderHeaderValueRemoteLoad forHTTPHeaderField:WtThunderHeaderKeyLoadType];
        _sessionID = wtThunderSessionID(urlString, userIdentifier);
        
        [self createTaskDelegate];
    }
    return self;
}

- (void)createTaskDelegate {
    _taskDelegate = [[WtURLSessionManagerTaskDelegate alloc] init];
    
    @weakify(self);
    [_taskDelegate.sessionDataDelegate selector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:) block:^(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response, void (^completionHandler)(NSURLSessionResponseDisposition disposition)){
        @strongify(self);
        [self URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    }];
    
    [_taskDelegate.sessionDataDelegate selector:@selector(URLSession:dataTask:didReceiveData:) block:^(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data){
        @strongify(self);
        [self URLSession:session dataTask:dataTask didReceiveData:data];
    }];
    
    [_taskDelegate.sessionTaskDelegate selector:@selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:) block:^(NSURLSession *session, NSURLSessionTask *task, NSHTTPURLResponse *response, NSURLRequest *request, void (^completionHandler)(NSURLRequest * _Nullable)){
        @strongify(self);
        [self URLSession:session task:task willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
    }];
    
    [_taskDelegate.sessionTaskDelegate selector:@selector(URLSession:task:didCompleteWithError:) block:^(NSURLSession *session, NSURLSessionTask *task, NSError *error){
        @strongify(self);
        [self URLSession:session task:task didCompleteWithError:error];
    }];
}

- (void)start {
    self.connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
    [self.connection setDelegateQueue:[WtThunderQueueManager connectionQueue]];
    [self.connection start];
    
    // 该方案仍无法解决第一次请求慢的问题，它不共享长链接
    // 留作试验
//    _sessionTask = [[WtThunderURLSessionManager shared] wtTaskWithRequest:_request delegate:_taskDelegate];
//    [_sessionTask resume];
}

- (void)cancel {
    [self.connection cancel];
    
//    if (_sessionTask && _sessionTask.state == NSURLSessionTaskStateRunning) {
//        [_sessionTask cancel];
//        [_session finishTasksAndInvalidate];
//    }else {
//        [_session invalidateAndCancel];
//    }
}

- (BOOL)isExpiredWithMaxAge:(NSTimeInterval)maxAge {
    return [[NSDate date] timeIntervalSince1970] > _sessionDidFinishTime + maxAge;
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _response = response;
    
    @weakify(self, response);
    wtDispatch_in_main(^{
        @strongify(self, response);
        if (self.delegate && [self.delegate respondsToSelector:@selector(session:didRecieveResponse:)]) {
            [self.delegate session:self didRecieveResponse:response];
        }
    });
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_responseData) {
        _responseData = [NSMutableData data];
        _responseDataArray = @[].mutableCopy;
    }
    
    data = [data copy];
    if (data) {
        [_responseData appendData:data];
        [_responseDataArray addObject:data];
        
        @weakify(self, data);
        wtDispatch_in_main(^{
            @strongify(self, data);
            if (self.delegate && [self.delegate respondsToSelector:@selector(session:didLoadData:)]) {
                [self.delegate session:self didLoadData:data];
            }
        });
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _error = error;
    _isCompletion = YES;
    
    @weakify(self, error);
    wtDispatch_in_main(^{
        @strongify(self, error);
        if (self.delegate && [self.delegate respondsToSelector:@selector(session:didFaild:)]) {
            [self.delegate session:self didFaild:error];
        }
    });
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _endTime = [[NSDate date] timeIntervalSince1970];
    NSString *t = [NSString stringWithFormat:@"%.0f", (_endTime - _beginTime)*1000 ];
    NSLog(@"[Glean Web BI]Session request takes %@ms", t);
    
    _isCompletion = YES;
    _sessionDidFinishTime = [[NSDate date] timeIntervalSince1970];
    
    @weakify(self);
    wtDispatch_in_main(^{
        @strongify(self);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WtThunderTaskDidCompleteNotification object:self];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sessionDidFinish:)]) {
            [self.delegate sessionDidFinish:self];
        }
    });
    
}

#pragma mark - private
- (void)session:(NSURLSession *)session didRecieveResponse:(NSHTTPURLResponse *)response {
    _response = response;
    
    @weakify(self, response);
    wtDispatch_in_main(^{
        @strongify(self, response);
        if (self.delegate && [self.delegate respondsToSelector:@selector(session:didRecieveResponse:)]) {
            [self.delegate session:self didRecieveResponse:response];
        }
    });
}

- (void)session:(NSURLSession *)session didLoadData:(NSData *)data {
    data = [data copy];
    @weakify(self, data);
    wtDispatch_in_main(^{
        @strongify(self, data);
        if (self.delegate && [self.delegate respondsToSelector:@selector(session:didLoadData:)]) {
            [self.delegate session:self didLoadData:data];
        }
    });
}

- (void)session:(NSURLSession *)session didFaild:(NSError *)error {
    if (error) {
        _error = error;
        _isCompletion = YES;
        
        @weakify(self, error);
        wtDispatch_in_main(^{
            @strongify(self, error);
            if (self.delegate && [self.delegate respondsToSelector:@selector(session:didFaild:)]) {
                [self.delegate session:self didFaild:error];
            }
        });
    }else {}
}

- (void)sessionDidFinish:(NSURLSession *)session {
    _endTime = [[NSDate date] timeIntervalSince1970];
    NSString *t = [NSString stringWithFormat:@"%.0f", (_endTime - _beginTime)*1000 ];
    NSLog(@"[Glean Web BI]Session request takes %@ms", t);
    
    _isCompletion = YES;
    _sessionDidFinishTime = [[NSDate date] timeIntervalSince1970];
    
    @weakify(self);
    wtDispatch_in_main(^{
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(sessionDidFinish:)]) {
            [self.delegate sessionDidFinish:self];
        }
    });
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
        _responseDataArray = @[].mutableCopy;
    }
    
    data = [data copy];
    if (data && data.length > 0) {
        [_responseData appendData:data];
        [_responseDataArray addObject:data];
        
        [self session:session didLoadData:data];
    }
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

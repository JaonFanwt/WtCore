//
//  WtThunderURLSessionManager.m
//  WtThunderWeb
//
//  Created by wtfan on 2017/9/12.
//

#import "WtThunderURLSessionManager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtCore.h"
#import "WtDispatch.h"

#import "WtThunderQueueManager.h"

@interface WtThunderURLSessionManager ()
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *mutableTaskDelegatesKeyedByTaskIdentifier;
@end

@implementation WtThunderURLSessionManager
+ (instancetype)shared {
    static WtThunderURLSessionManager *kWtThunderURLSessionManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kWtThunderURLSessionManager = [[WtThunderURLSessionManager alloc] init];
    });
    return kWtThunderURLSessionManager;
}

- (instancetype)init {
    return [self initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super init]) {
        if (!configuration) {
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        
        _sessionConfiguration = configuration;
        
        _lock = [[NSRecursiveLock alloc] init];
        
        _session = [NSURLSession sessionWithConfiguration:_sessionConfiguration delegate:self delegateQueue:[WtThunderQueueManager connectionQueue]];
        
        _mutableTaskDelegatesKeyedByTaskIdentifier = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public
- (NSURLSessionTask *)wtTaskWithRequest:(NSURLRequest *)request
                               delegate:(WtURLSessionManagerTaskDelegate *)delegate {
    NSURLSessionTask *sessionTask = [_session dataTaskWithRequest:request];
    [self setDelegate:delegate forTask:sessionTask];
    return sessionTask;
}

#pragma mark -
- (WtURLSessionManagerTaskDelegate *)delegateForTask:(NSURLSessionTask *)task {
    WtURLSessionManagerTaskDelegate *delegate = nil;
    [self.lock lock];
    delegate = _mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)];
    [self.lock unlock];
    
    return delegate;
}

- (void)setDelegate:(WtURLSessionManagerTaskDelegate *)delegate forTask:(NSURLSessionTask *)task {
    [self.lock lock];
    _mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)] = delegate;
    [self.lock unlock];
}

- (void)removeDelegateForTask:(NSURLSessionTask *)task {
    [self.lock lock];
    [_mutableTaskDelegatesKeyedByTaskIdentifier removeObjectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
    WtURLSessionManagerTaskDelegate *delegate = [self delegateForTask:dataTask];
    [delegate.sessionDataDelegate URLSession:session dataTask:dataTask didReceiveResponse:response
                           completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    data = [data copy];
    WtURLSessionManagerTaskDelegate *delegate = [self delegateForTask:dataTask];
    [delegate.sessionDataDelegate URLSession:session dataTask:dataTask didReceiveData:data];
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    completionHandler(request);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
    WtURLSessionManagerTaskDelegate *delegate = [self delegateForTask:task];
    [delegate.sessionTaskDelegate URLSession:session task:task didCompleteWithError:error];
    
    [self removeDelegateForTask:task];
}
@end

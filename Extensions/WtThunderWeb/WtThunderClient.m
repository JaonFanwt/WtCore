//
//  WtThunderClient.m
//  Pods
//
//  Created by wtfan on 2017/8/29.
//
//

#import "WtThunderClient.h"

#import "WtThunderConstants.h"

NSURLRequest *wtThunderProduceWebRequest(NSURLRequest *request, NSString *userIdentifier) {
    NSMutableURLRequest *wrapRequest = [request mutableCopy];
    [wrapRequest setValue:WtThunderHeaderValueProduceLoad forHTTPHeaderField:WtThunderHeaderKeyLoadType];
    if (userIdentifier && userIdentifier.length > 0) {
        [wrapRequest setValue:userIdentifier forHTTPHeaderField:WtThunderHeaderKeySessionUserIdentifier];
    }
    return wrapRequest;
}

NSURLRequest *wtThunderConsumeWebRequest(NSURLRequest *request, NSString *userIdentifier) {
    NSMutableURLRequest *wrapRequest = [request mutableCopy];
    [wrapRequest setValue:WtThunderHeaderValueConsumeLoad forHTTPHeaderField:WtThunderHeaderKeyLoadType];
    if (userIdentifier && userIdentifier.length > 0) {
        [wrapRequest setValue:userIdentifier forHTTPHeaderField:WtThunderHeaderKeySessionUserIdentifier];
    }
    return wrapRequest;
}

@interface WtThunderClient ()
<WtThunderSessionDelegate>
@property (nonatomic, strong) NSRecursiveLock *lock;

@property (nonatomic, strong) NSMutableDictionary<NSString *, WtThunderSession *> *sessionMapping;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *proxyMapping;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *urlStringWorkingMapping; // value: isConsumer

@property (nonatomic, strong) NSMutableDictionary<NSString *, WtThunderSession *> *cacheSessionMapping;
@end

@implementation WtThunderClient
+ (instancetype)shared {
    static WtThunderClient* kWtThunderClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kWtThunderClient = [[WtThunderClient alloc] init];
    });
    return kWtThunderClient;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = [[NSRecursiveLock alloc] init];
        
        _cacheControlMaxAge = 10;
        
        _sessionMapping = @{}.mutableCopy;
        _proxyMapping = @{}.mutableCopy;
        _urlStringWorkingMapping = @{}.mutableCopy;
        
        _cacheSessionMapping = @{}.mutableCopy;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning:(id)sender {
    [_cacheSessionMapping removeAllObjects];
}

- (void)newSessionWithUrlString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier isConsumer:(BOOL)isConsumer delegateProxy:(WtDelegateProxy<WtThunderSessionDelegate> *)proxy {
    NSString *sessionID = wtThunderSessionID(urlString, userIdentifier);
    
    [_lock lock];
    
    _urlStringWorkingMapping[urlString] = [NSNumber numberWithBool:([_urlStringWorkingMapping[urlString] boolValue] || isConsumer)];
    
    WtThunderSession *cacheSession = _cacheSessionMapping[sessionID];
    BOOL isCacheSessionExpired = [cacheSession isExpiredWithMaxAge:_cacheControlMaxAge];
    if (isCacheSessionExpired) {
        _urlStringWorkingMapping[urlString] = [NSNumber numberWithBool:isConsumer];
        [_cacheSessionMapping removeObjectForKey:sessionID];
    }
    
    if (cacheSession && !isCacheSessionExpired) {
        if (proxy) [_proxyMapping[sessionID] addObject:proxy];
        
        [self session:cacheSession didRecieveResponse:cacheSession.response];
        [self session:cacheSession didLoadData:cacheSession.responseData];
        [self sessionDidFinish:cacheSession];
        
        [_cacheSessionMapping removeObjectForKey:sessionID];
    }else {
        WtThunderSession *session = _sessionMapping[sessionID];
        if (session) {
            // Block Mapping
            if (proxy) [_proxyMapping[sessionID] addObject:proxy];
        }else {
            // Session
            session = [[WtThunderSession alloc] initWithURLString:urlString userIdentifier:userIdentifier];
            session.delegate = self;
            _sessionMapping[sessionID] = session;
            
            [session start];
            
            // Block Mapping
            NSMutableArray *proxyArray = [[NSMutableArray alloc] init];
            if (proxy) [proxyArray addObject:proxy];
            _proxyMapping[sessionID] = proxyArray;
        }
    }
    
    [_lock unlock];
}

#pragma mark - public
- (void)createSessionWithUrlString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier delegateProxy:(WtDelegateProxy<WtThunderSessionDelegate> *)proxy {
    [self newSessionWithUrlString:urlString userIdentifier:userIdentifier isConsumer:NO delegateProxy:proxy];
}

- (void)consumeSessionWithUrlString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier delegateProxy:(WtDelegateProxy<WtThunderSessionDelegate> *)proxy {
    [self newSessionWithUrlString:urlString userIdentifier:userIdentifier isConsumer:YES delegateProxy:proxy];
}

- (BOOL)isExistSessionWithUrlString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier {
    BOOL isExist = _urlStringWorkingMapping[urlString]?YES:NO;
    
    return isExist;
}

#pragma mark - WtThunderSessionDelegate
- (void)session:(WtThunderSession *)session didRecieveResponse:(NSURLResponse *)response {
    [_lock lock];
    
    for (WtDelegateProxy<WtThunderSessionDelegate> *proxy in _proxyMapping[session.sessionID]) {
        [proxy session:session didRecieveResponse:response];
    }
    
    [_lock unlock];
}

- (void)session:(WtThunderSession *)session didLoadData:(NSData *)date {
    [_lock lock];
    
    for (WtDelegateProxy<WtThunderSessionDelegate> *proxy in _proxyMapping[session.sessionID]) {
        [proxy session:session didLoadData:date];
    }
    
    [_lock unlock];
}

- (void)session:(WtThunderSession *)session didFaild:(NSError *)error {
    [_lock lock];
    
    for (WtDelegateProxy<WtThunderSessionDelegate> *proxy in _proxyMapping[session.sessionID]) {
        [proxy session:session didFaild:error];
    }
    [_proxyMapping[session.sessionID] removeAllObjects];
    [_sessionMapping removeObjectForKey:session.sessionID];
    [_urlStringWorkingMapping removeObjectForKey:session.urlString];
    
    [_lock unlock];
    
    NSLog(@"[Glean Web BI]%s - %@", __func__, session.urlString);
}

- (void)sessionDidFinish:(WtThunderSession *)session {
    [_lock lock];
    
    for (WtDelegateProxy<WtThunderSessionDelegate> *proxy in _proxyMapping[session.sessionID]) {
        [proxy sessionDidFinish:session];
    }
    [_proxyMapping[session.sessionID] removeAllObjects];
    [_sessionMapping removeObjectForKey:session.sessionID];
    
    BOOL isConsumer = [_urlStringWorkingMapping[session.urlString] boolValue];
    if (!isConsumer) {
        [_cacheSessionMapping setObject:session forKey:session.sessionID];
    }else {}
    
    [_lock unlock];
    
    NSLog(@"[Glean Web BI]%s - %@", __func__, session.urlString);
}
@end

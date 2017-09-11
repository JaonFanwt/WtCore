//
//  UIWebView+WtObserver.m
//  Pods
//
//  Created by wtfan on 2017/8/16.
//
//

#import "UIWebView+WtObserver.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtSwizzle.h"
#import "WtDelegateProxy.h"

@implementation UIWebView (WtObserver)
+ (void)load {
    wt_swizzleSelector([self class], @selector(init), @selector(swizzle_init));
    wt_swizzleSelector([self class], @selector(initWithFrame:), @selector(swizzle_initWithFrame:));
    wt_swizzleSelector([self class], @selector(initWithCoder:), @selector(swizzle_initWithCoder:));
    wt_swizzleSelector([self class], @selector(awakeFromNib), @selector(swizzle_awakeFromNib));
    wt_swizzleSelector([self class], @selector(setDelegate:), @selector(swizzle_setDelegate:));
    wt_swizzleSelector([self class], @selector(loadRequest:), @selector(swizzle_loadRequest:));
}

#pragma mark - private
- (void)setTimeInterval:(NSTimeInterval)timeInterval sel:(SEL)sel {
    assert(sel != nil);
    objc_setAssociatedObject(self, sel, @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)getTimeIntervalWithSEL:(SEL)sel {
    assert(sel != nil);
    NSTimeInterval t = [objc_getAssociatedObject(self, sel) doubleValue];
    return t;
}

- (WtDelegateProxy<UIWebViewDelegate> *)delegateProxy {
    WtDelegateProxy<UIWebViewDelegate> *proxy = objc_getAssociatedObject(self, _cmd);
    if (!proxy) {
        proxy = (WtDelegateProxy<UIWebViewDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UIWebViewDelegate)];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        @weakify(self);
        [proxy selector:@selector(webView:shouldStartLoadWithRequest:navigationType:) block:^(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType){
            @strongify(self);
            BOOL b = true;
            
            if ([self wrapDelegate] &&
                [[self wrapDelegate] respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
                b = [[self wrapDelegate] webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
            }
            
            return b;
        }];
        
        [proxy selector:@selector(webViewDidStartLoad:) block:^(UIWebView *webView){
            @strongify(self);
            NSTimeInterval startTime = [self startDidStartLoadTime];
            if (startTime == 0) {
                [self willChangeValueForKey:@"startDidStartLoadTime"];
                startTime = [[NSDate date] timeIntervalSince1970];
                [self setTimeInterval:startTime sel:@selector(startDidStartLoadTime)];
                [self didChangeValueForKey:@"startDidStartLoadTime"];
            }
            
            if ([self wrapDelegate] &&
                [[self wrapDelegate] respondsToSelector:@selector(webViewDidStartLoad:)]) {
                [[self wrapDelegate] webViewDidStartLoad:webView];
            }
            
            NSTimeInterval endTime = [self endDidStartLoadTime];
            if (endTime == 0) {
                [self willChangeValueForKey:@"endDidStartLoadTime"];
                endTime = [[NSDate date] timeIntervalSince1970];
                [self setTimeInterval:endTime sel:@selector(endDidStartLoadTime)];
                [self didChangeValueForKey:@"endDidStartLoadTime"];
                
                NSLog(@"(%p)[%@ Till webViewDidStartLoad first finished consumed time]: %.0fms", self, [self class], (endTime - self.startInitTime)*1000);
            }
            
        }];
        
        [proxy selector:@selector(webViewDidFinishLoad:) block:^(UIWebView *webView){
            @strongify(self);
            NSTimeInterval startTime = [self startDidFinishLoadTime];
            if (startTime == 0) {
                [self willChangeValueForKey:@"startDidFinishLoadTime"];
                startTime = [[NSDate date] timeIntervalSince1970];
                [self setTimeInterval:startTime sel:@selector(startDidFinishLoadTime)];
                [self didChangeValueForKey:@"startDidFinishLoadTime"];
            }
            
            if ([self wrapDelegate] &&
                [[self wrapDelegate] respondsToSelector:@selector(webViewDidFinishLoad:)]) {
                [[self wrapDelegate] webViewDidFinishLoad:webView];
            }
            
            NSTimeInterval endTime = [self endDidFinishLoadTime];
            if (endTime == 0) {
                [self willChangeValueForKey:@"endDidFinishLoadTime"];
                endTime = [[NSDate date] timeIntervalSince1970];
                [self setTimeInterval:endTime sel:@selector(endDidFinishLoadTime)];
                [self didChangeValueForKey:@"endDidFinishLoadTime"];
                
                NSLog(@"(%p)[%@ Till webViewDidFinishLoad first finished consumed time]: %.0fms", self, [self class], (endTime - self.startInitTime)*1000);
            }
            
        }];
        
        [proxy selector:@selector(webView:didFailLoadWithError:) block:^(UIWebView *webView, NSError *error){
            @strongify(self);
            if ([self wrapDelegate] &&
                [[self wrapDelegate] respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
                [[self wrapDelegate] webView:webView didFailLoadWithError:error];
            }
            
        }];
    }
    
    return proxy;
}

#pragma mark - overwrite
- (id<UIWebViewDelegate>)delegate {
    return [self wrapDelegate];
}

#pragma mark - private property
- (id<UIWebViewDelegate>)wrapDelegate {
    id<UIWebViewDelegate> d = objc_getAssociatedObject(self, @selector(wrapDelegate));
    return d;
}

- (void)setWrapDelegate:(id<UIWebViewDelegate>)wrapDelegate {
    objc_setAssociatedObject(self, @selector(wrapDelegate), wrapDelegate, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - public property
- (NSTimeInterval)startInitTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)startDidStartLoadTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)endDidStartLoadTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)startLoadRequestTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)endLoadRequestTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)startDidFinishLoadTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)endDidFinishLoadTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

#pragma mark - swizzle methods
- (instancetype)swizzle_init {
    [self willChangeValueForKey:@"startInitTime"];
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self setTimeInterval:startTime sel:@selector(startInitTime)];
    [self didChangeValueForKey:@"startInitTime"];
    
    UIWebView *obj = [self swizzle_init];
    obj.delegate = [obj delegateProxy];
    
    return obj;
}

- (instancetype)swizzle_initWithFrame:(CGRect)frame {
    [self willChangeValueForKey:@"startInitTime"];
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self setTimeInterval:startTime sel:@selector(startInitTime)];
    [self didChangeValueForKey:@"startInitTime"];
    
    UIWebView *obj = [self swizzle_initWithFrame:frame];
    obj.delegate = [obj delegateProxy];
    
    return obj;
}

- (void)swizzle_awakeFromNib {
    [self willChangeValueForKey:@"startInitTime"];
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self setTimeInterval:startTime sel:@selector(startInitTime)];
    [self didChangeValueForKey:@"startInitTime"];
    
    [self swizzle_awakeFromNib];
    self.delegate = [self delegateProxy];
}

- (nullable instancetype)swizzle_initWithCoder:(NSCoder *)aDecoder {
    [self willChangeValueForKey:@"startInitTime"];
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self setTimeInterval:startTime sel:@selector(startInitTime)];
    [self didChangeValueForKey:@"startInitTime"];
    
    UIWebView *obj = [self swizzle_initWithCoder:aDecoder];
    obj.delegate = [obj delegateProxy];
    
    return obj;
}

- (void)swizzle_setDelegate:(id<UIWebViewDelegate>)delegate {
    if (delegate == [self delegateProxy]) {
        [self swizzle_setDelegate:delegate];
    }else {
        [self setWrapDelegate:delegate];
    }
}

- (void)swizzle_loadRequest:(NSURLRequest *)request {
    NSTimeInterval startTime = [self startLoadRequestTime];
    if (startTime == 0) {
        [self willChangeValueForKey:@"startLoadRequestTime"];
        startTime = [[NSDate date] timeIntervalSince1970];
        [self setTimeInterval:startTime sel:@selector(startLoadRequestTime)];
        [self didChangeValueForKey:@"startLoadRequestTime"];
    }
    
    [self swizzle_loadRequest:request];
    
    NSTimeInterval endTime = [self endLoadRequestTime];
    if (endTime == 0) {
        [self willChangeValueForKey:@"endLoadRequestTime"];
        endTime = [[NSDate date] timeIntervalSince1970];
        [self setTimeInterval:endTime sel:@selector(endLoadRequestTime)];
        [self didChangeValueForKey:@"endLoadRequestTime"];
    }
    
    NSLog(@"(%p)[%@ Till webViewLoadRequest first finished consumed time]: %.0fms", self, [self class], (endTime - self.startInitTime)*1000);
}
@end

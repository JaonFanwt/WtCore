//
//  UIViewController+WtObserver.m
//  Pods
//
//  Created by wtfan on 2017/8/16.
//
//

#import "UIViewController+WtObserver.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "WtSwizzle.h"

@implementation UIViewController (WtObserver)
+ (void)load {
    wt_swizzleSelector([self class], @selector(initWithNibName:bundle:), @selector(swizzled_initWithNibName:bundle:));
    wt_swizzleSelector([self class], @selector(initWithCoder:), @selector(swizzled_initWithCoder:));
    wt_swizzleSelector([self class], @selector(viewDidLoad), @selector(swizzled_viewDidLoad));
    wt_swizzleSelector([self class], @selector(viewWillAppear:), @selector(swizzled_viewWillAppear:));
    wt_swizzleSelector([self class], @selector(viewDidAppear:), @selector(swizzled_viewDidAppear:));
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval sel:(SEL)sel {
    assert(sel != nil);
    objc_setAssociatedObject(self, sel, @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)getTimeIntervalWithSEL:(SEL)sel {
    assert(sel != nil);
    NSTimeInterval t = [objc_getAssociatedObject(self, sel) doubleValue];
    return t;
}

- (NSTimeInterval)startInitTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)startViewDidLoadTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)endViewDidLoadTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)startViewWillAppearTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)endViewWillAppearTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)startViewDidAppearTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

- (NSTimeInterval)endViewDidAppearTime {
    return [self getTimeIntervalWithSEL:_cmd];
}

#pragma mark swizzle methods
- (instancetype)swizzled_initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    [self willChangeValueForKey:@"startInitTime"];
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self setTimeInterval:startTime sel:@selector(startInitTime)];
    [self didChangeValueForKey:@"startInitTime"];
    
    id s = [self swizzled_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return s;
}

- (nullable instancetype)swizzled_initWithCoder:(NSCoder *)aDecoder {
    [self willChangeValueForKey:@"startInitTime"];
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    [self setTimeInterval:startTime sel:@selector(startInitTime)];
    [self didChangeValueForKey:@"startInitTime"];
    
    id s = [self swizzled_initWithCoder:aDecoder];
    
    return s;
}

- (void)swizzled_viewDidLoad {
    if ([self getTimeIntervalWithSEL:@selector(startViewDidLoadTime)] == 0) {
        [self willChangeValueForKey:@"startViewDidLoadTime"];
        NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
        [self setTimeInterval:startTime sel:@selector(startViewDidLoadTime)];
        [self didChangeValueForKey:@"startViewDidLoadTime"];
        
        [self swizzled_viewDidLoad];
        
        [self willChangeValueForKey:@"endViewDidLoadTime"];
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
        [self setTimeInterval:endTime sel:@selector(endViewDidLoadTime)];
        [self didChangeValueForKey:@"endViewDidLoadTime"];
        
        NSLog(@"(%p)[%@ Till ViewDidLoad finished consumed time]: %.0fms", self, [self class], (startTime - self.startInitTime )*1000);
    }
}

- (void)swizzled_viewWillAppear:(BOOL)animated {
    if ([self getTimeIntervalWithSEL:@selector(startViewWillAppearTime)] == 0) {
        [self willChangeValueForKey:@"startViewWillAppearTime"];
        NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
        [self setTimeInterval:startTime sel:@selector(startViewWillAppearTime)];
        [self didChangeValueForKey:@"startViewWillAppearTime"];
        
        [self swizzled_viewWillAppear:animated];
        
        [self willChangeValueForKey:@"endViewWillAppearTime"];
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
        [self setTimeInterval:endTime sel:@selector(endViewWillAppearTime)];
        [self didChangeValueForKey:@"endViewWillAppearTime"];
        
        NSLog(@"(%p)[%@ Till ViewWillAppear finished consumed time]: %.0fms", self, [self class], (startTime - self.startInitTime)*1000);
    }
}

- (void)swizzled_viewDidAppear:(BOOL)animated {
    if ([self getTimeIntervalWithSEL:@selector(startViewDidAppearTime)] == 0) {
        [self willChangeValueForKey:@"startViewDidAppearTime"];
        NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
        [self setTimeInterval:startTime sel:@selector(startViewDidAppearTime)];
        [self didChangeValueForKey:@"startViewDidAppearTime"];
        
        [self swizzled_viewDidAppear:animated];
        
        [self willChangeValueForKey:@"endViewDidAppearTime"];
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
        [self setTimeInterval:endTime sel:@selector(endViewDidAppearTime)];
        [self didChangeValueForKey:@"endViewDidAppearTime"];
        
        NSLog(@"(%p)[%@ Till ViewDidAppear finished consumed time]: %.0fms", self, [self class], (startTime - self.startInitTime)*1000);
    }
}
@end

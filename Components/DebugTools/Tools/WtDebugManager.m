//
//  WtDebugManager.m
//  WtDebugTools
//
//  Created by wtfan on 2017/9/11.
//
//

#import "WtDebugManager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation WtDebugManager
+ (instancetype)shared {
    static WtDebugManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WtDebugManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        @weakify(self);
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
            @strongify(self);
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.isDebugOn] forKey:@"WtDebugOn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
    return self;
}

- (BOOL)isDebugOn {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _isDebugOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"WtDebugOn"] boolValue];
    });
    return _isDebugOn;
}
@end

//
//  WtDebugSwitchNetworkManager.m
//  WtDebugTools
//
//  Created by wtfan on 2017/5/24.
//
//

#import "WtDebugSwitchNetworkManager.h"

#import "WtDebugSwitchNetworkDB.h"


@interface WtDebugSwitchNetworkManager ()
@property (nonatomic, strong) NSArray<WtDebugSwitchNetworkGroup *> *privateNetworkGroups;
@end


@implementation WtDebugSwitchNetworkManager
+ (instancetype)sharedManager {
  static WtDebugSwitchNetworkManager *manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[WtDebugSwitchNetworkManager alloc] init];
  });
  return manager;
}

- (instancetype)init {
  if (self = [super init]) {
    _privateNetworkGroups = [WtDebugSwitchNetworkDB loadFromCache];
    [self createActions];
  }
  return self;
}

- (NSArray *)networkGroups {
  [self createNetworkGroupsIfNecessary];
  return _privateNetworkGroups;
}

- (void)createNetworkGroupsIfNecessary {
  if (!_privateNetworkGroups) {
    if (_initialNetworkGroupsIfNecessary) {
      _privateNetworkGroups = _initialNetworkGroupsIfNecessary();
    }
  }
}

- (void)createActions {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)handleApplicationDidEnterBackgroundNotification {
  [WtDebugSwitchNetworkDB cacheToCache:self.privateNetworkGroups];
}

#pragma mark - public
- (WtDebugSwitchNetworkGroup *)networkGroup:(NSString *)key {
  if (!key) return nil;

  for (WtDebugSwitchNetworkGroup *group in _privateNetworkGroups) {
    if ([group.key isEqualToString:key]) {
      return group;
    }
  }

  return nil;
}
@end

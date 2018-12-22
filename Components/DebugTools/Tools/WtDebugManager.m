//
//  WtDebugManager.m
//  WtDebugTools
//
//  Created by wtfan on 2017/9/11.
//
//

#import "WtDebugManager.h"

#import "WtEXTScope.h"


@implementation WtDebugManager
+ (instancetype)shared {
  static WtDebugManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[WtDebugManager alloc] init];
  });
  return manager;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
  if (self = [super init]) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
  }
  return self;
}

- (void)handleApplicationDidEnterBackgroundNotification {
  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.isDebugOn] forKey:@"WtDebugOn"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isDebugOn {
  @weakify(self);
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    @strongify(self);
    self.isDebugOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"WtDebugOn"] boolValue];
  });
  return _isDebugOn;
}
@end

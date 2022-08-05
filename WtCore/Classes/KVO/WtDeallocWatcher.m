//
//  WtDeallocWatcher.m
//  WtCore
//
//  Created by fan weitian on 2018/8/27.
//

#import "WtDeallocWatcher.h"

@implementation WtDeallocWatcher

- (void)dealloc {
  if (_whenDeallocBlock) {
    _whenDeallocBlock();
  }
}

+ (instancetype)watcher:(void (^)(void))whenDeallocBlock {
  WtDeallocWatcher *obj = [[WtDeallocWatcher alloc] init];
  obj.whenDeallocBlock = whenDeallocBlock;
  return obj;
}

@end

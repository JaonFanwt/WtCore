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
    _whenDeallocBlock(_owner);
  }
}

+(instancetype)watcher:(void (^)(id owner))whenDeallocBlock owner:(id)owner {
  WtDeallocWatcher *obj = [[WtDeallocWatcher alloc] init];
  obj.owner = owner;
  obj.whenDeallocBlock = whenDeallocBlock;
  return obj;
}
@end

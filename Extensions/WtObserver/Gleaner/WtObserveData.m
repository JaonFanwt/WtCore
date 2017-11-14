//
//  WtObserveData.m
//  WtObserver
//
//  Created by wtfan on 2017/8/24.
//
//

#import "WtObserveData.h"

@implementation WtObserveData
- (instancetype)initWithName:(NSString *)name keys:(NSArray *)keys {
    if (self = [super init]) {
        _name = name;
        _keys = [NSMutableSet setWithArray:keys];
        _values = @{}.mutableCopy;
    }
    return self;
}

- (BOOL)hasKey:(NSString *)key {
    for (NSString *k in _keys) {
        if ([k isEqualToString:key]) {
            return YES;
        }
    }
    return NO;
}

- (void)addKey:(NSString *)key {
    if (!key || key.length == 0) return;
    [_keys addObject:key];
}

- (void)addValue:(id)value withKey:(NSString *)key {
    if (!value || !key || key.length == 0) return;
    
    NSMutableArray *valuesWithKey = _values[key];
    if (!valuesWithKey) {
        valuesWithKey = [[NSMutableArray alloc] initWithCapacity:3];
        _values[key] = valuesWithKey;
    }
    
    [valuesWithKey addObject:value];
}
@end

//
//  WtObserveData.h
//  Pods
//
//  Created by wtfan on 2017/8/24.
//
//

#import <Foundation/Foundation.h>

@interface WtObserveData : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSMutableSet *keys;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSMutableArray *> *values;
- (instancetype)initWithName:(NSString *)name keys:(NSArray *)keys;
- (BOOL)hasKey:(NSString *)key;
- (void)addKey:(NSString *)key;
- (void)addValue:(id)value withKey:(NSString *)key;
@end

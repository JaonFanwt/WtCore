//
//  WtObserveDataGleaner.m
//  WtObserver
//
//  Created by wtfan on 2017/8/24.
//
//

#import "WtObserveDataGleaner.h"

#import "WtObserveDataWritter.h"


@implementation WtObserveDataGleaner
+ (instancetype)shared {
  static WtObserveDataGleaner *gleaner;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gleaner = [[WtObserveDataGleaner alloc] init];
  });
  return gleaner;
}

- (instancetype)init {
  if (self = [super init]) {
    _treasures = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self loadDataFromCache];
  }
  return self;
}

- (NSString *)cacheToDisk {
  NSMutableDictionary *cache = @{}.mutableCopy;
  for (NSString *name in _treasures.allKeys) {
    cache[name] = @{}.mutableCopy;
    WtObserveData *data = _treasures[name];
    for (NSString *columnName in data.keys) {
      cache[name][columnName] = @[].mutableCopy;
      for (NSNumber *num in data.values[columnName]) {
        [cache[name][columnName] addObject:num];
      }
    }
  }

  NSString *path = [WtObserveDataWritter path];
  wtPathCreateIfNotExists(path);
  NSString *filePath = [path stringByAppendingPathComponent:@"cache.plist"];
  [cache writeToFile:filePath atomically:YES];

  return filePath;
}

- (void)loadDataFromCache {
  NSString *path = [WtObserveDataWritter path];
  NSString *filePath = [path stringByAppendingPathComponent:@"cache.plist"];
  NSDictionary<NSString *, NSDictionary<NSString *, NSArray<NSNumber *> *> *> *data = [NSDictionary dictionaryWithContentsOfFile:filePath];
  for (NSString *name in data.allKeys) {
    NSDictionary<NSString *, NSArray<NSNumber *> *> *observeData = data[name];
    WtObserveData *data = [[WtObserveData alloc] initWithName:name keys:observeData.allKeys];
    for (NSString *columnName in observeData.allKeys) {
      for (NSNumber *num in observeData[columnName]) {
        [data addValue:num withKey:columnName];
      }
    }
    _treasures[name] = data;
  }
}

- (void)glean:(NSString *)name columnName:(NSString *)columnName value:(id)value error:(NSError **)error {
  if (!name || name.length == 0) {
    if (error) {
      NSString *domain = [NSString stringWithFormat:@"[%@] - 搜集名为空.", [self class]];
      *error = [NSError errorWithDomain:domain code:eWtObserveDataGleanNameNilError userInfo:nil];
    }
    return;
  }

  if (!value) {
    if (error) {
      NSString *domain = [NSString stringWithFormat:@"[%@] - 搜集数据为空.", [self class]];
      *error = [NSError errorWithDomain:domain code:eWtObserveDataGleanValueNilError userInfo:nil];
    }
    return;
  }

  WtObserveData *treasure = _treasures[name];
  if (!treasure) {
    treasure = [[WtObserveData alloc] initWithName:name keys:@[ columnName ]];
    _treasures[name] = treasure;
  }

  if (![treasure hasKey:columnName]) {
    [treasure addKey:columnName];
  }

  [treasure addValue:value withKey:columnName];
}

@end

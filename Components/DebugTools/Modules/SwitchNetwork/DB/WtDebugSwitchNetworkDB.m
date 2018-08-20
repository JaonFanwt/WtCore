//
//  WtDebugSwitchNetworkDB.m
//  WtDebugTools
//
//  Created by wtfan on 2017/5/23.
//
//

#import "WtDebugSwitchNetworkDB.h"

#import "WtDebugSwitchNetworkItem.h"
#import "WtDebugBundle.h"

#define WtPathCreateIfNotExists(path)                            \
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) { \
    [[NSFileManager defaultManager] createDirectoryAtPath:path   \
                              withIntermediateDirectories:YES    \
                                               attributes:nil    \
                                                    error:NULL]; \
  }

static NSString *kWtDebugSwitchNetworkConfigPlist = @"DebugSwitchNetworkConfig.plist";


@implementation WtDebugSwitchNetworkDB
+ (NSArray<WtDebugSwitchNetworkGroup *> *)convertFromPlistData:(NSArray *)array {
  if (!array) return nil;

  NSMutableArray *results = @[].mutableCopy;
  for (NSDictionary *groupDict in array) {
    NSString *key = groupDict[@"key"];
    NSString *name = groupDict[@"name"];
    WtDebugSwitchNetworkGroup *group = [[WtDebugSwitchNetworkGroup alloc] init];
    group.key = key;
    group.name = name;
    for (NSDictionary *modelDict in groupDict[@"urls"]) {
      WtDebugSwitchNetworkItem *model = [[WtDebugSwitchNetworkItem alloc] init];
      model.urlString = modelDict[@"url"];
      model.urlDescription = modelDict[@"description"];
      model.isSelected = [modelDict[@"isSelected"] boolValue];
      [group addModel:model];
    }
    [results addObject:group];
  }

  return results;
}

+ (NSArray *)convertFromModel:(NSArray<WtDebugSwitchNetworkGroup *> *)array {
  if (!array) return nil;

  NSMutableArray *results = @[].mutableCopy;
  for (WtDebugSwitchNetworkGroup *group in array) {
    NSMutableDictionary *groupDict = @{}.mutableCopy;
    groupDict[@"key"] = group.key;
    groupDict[@"name"] = group.name;
    groupDict[@"urls"] = @[].mutableCopy;
    [results addObject:groupDict];
    for (WtDebugSwitchNetworkItem *model in group.models) {
      NSMutableDictionary *modelDict = @{}.mutableCopy;
      if (model.urlString) modelDict[@"url"] = model.urlString;
      if (model.urlDescription) modelDict[@"description"] = model.urlDescription;
      modelDict[@"isSelected"] = [NSNumber numberWithBool:model.isSelected];
      [groupDict[@"urls"] addObject:modelDict];
    }
  }
  return results;
}

+ (NSString *)cachedPlistPath {
  NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support"];
  WtPathCreateIfNotExists(cachePath);
  NSString *plistPath = [cachePath stringByAppendingPathComponent:kWtDebugSwitchNetworkConfigPlist];
  return plistPath;
}

+ (NSArray<WtDebugSwitchNetworkGroup *> *)loadFromCache {
  NSString *plistPath = [self cachedPlistPath];
  NSData *data = [NSData dataWithContentsOfFile:plistPath];

  if (!data) return nil;
  NSArray *networkGroups = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  NSArray<WtDebugSwitchNetworkGroup *> *results = [self convertFromPlistData:networkGroups];

  return results;
}

+ (void)cacheToCache:(NSArray<WtDebugSwitchNetworkGroup *> *)array {
  NSArray *dataArray = [self convertFromModel:array];
  if (!dataArray) return;

  NSData *resultData = [NSKeyedArchiver archivedDataWithRootObject:dataArray];
  [resultData writeToFile:[self cachedPlistPath] atomically:YES];
}
@end

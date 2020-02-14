//
// NSURL+WtExtension.m
// WtCore
//
// Created by wtfan on 2017/8/30.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import "NSURL+WtExtension.h"


@implementation NSURL (WtExtension)

#pragma mark - private
- (NSArray<NSURLQueryItem *> *)_wtQueryItemsWithParameters:(NSDictionary<NSString *, NSString *> *)dict {
  NSMutableArray<NSURLQueryItem *> *items = @[].mutableCopy;
  if (!dict || ![dict isKindOfClass:NSDictionary.class] || dict.count == 0) return nil;
  
  [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
    NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:obj];
    [items addObject:item];
  }];
  
  return items;
}

#pragma mark - query
- (NSDictionary<NSString *, NSArray<NSString *> *> *)wtQueryComponents {
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  NSMutableDictionary<NSString *, NSMutableArray<NSString *> *> *queries = @{}.mutableCopy;
  [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
   NSMutableArray *params = queries[obj.name];
   if (!params) {
     params = @[].mutableCopy;
     queries[obj.name] = params;
   }
   [params addObject:obj.value];
  }];
  return queries;
}

- (NSDictionary<NSString *, NSString *> *)wtQueryComponentsWithNoDuplicate {
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  NSMutableDictionary<NSString *, NSString *> *queries = @{}.mutableCopy;
  [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
   if (!queries[obj.name]) {
     queries[obj.name] = obj.value;
   }
  }];
  return queries;
}

- (NSString *)wtQueryComponentNamed:(NSString *)name index:(NSInteger)index {
  NSArray<NSString *> *params = [self wtQueryComponentNamed:name];
  if (index < params.count) {
    return params[index];
  }
  return nil;
}

- (NSArray<NSString *> *)wtQueryComponentNamed:(NSString *)name {
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  NSMutableArray<NSString *> *results = @[].mutableCopy;
  [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj.name isEqualToString:name]) {
      [results addObject:obj.value];
    }
  }];
  return results;
}

#pragma mark - NSURL
- (NSURL *)wtSortedByCompareQueryComponents {
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  urlComponents.queryItems = [urlComponents.queryItems sortedArrayUsingComparator:^NSComparisonResult(NSURLQueryItem *obj1, NSURLQueryItem * obj2) {
    return [obj1.name compare:obj2.name];
  }];
  return urlComponents.URL;
}

- (NSURL *)wtRemoveQueries:(NSArray<NSString *> *)queries {
  return [self wtRemoveQueries:queries caseSensitive:YES];
}

- (NSURL *)wtRemoveQueries:(NSArray<NSString *> *)queries caseSensitive:(BOOL)caseSensitive {
  if (!queries || queries.count == 0) return self;
  
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  NSMutableDictionary<NSString *, NSString *> *queriesMapping = @{}.mutableCopy;
  [queries enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if (obj.length == 0) return;
    
    if (caseSensitive) {
      queriesMapping[obj] = obj;
    } else {
      queriesMapping[obj.lowercaseString] = obj;
    }
  }];
  
  NSMutableArray *wrappedQueryItems = urlComponents.queryItems.mutableCopy;
  [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSString *name = caseSensitive ? obj.name : obj.name.lowercaseString;
    if (queriesMapping[name]) {
      [wrappedQueryItems removeObject:obj];
    }
  }];
  
  urlComponents.queryItems = wrappedQueryItems;
  return urlComponents.URL;
}

#pragma mark - Converts to NSString
- (NSString *)wtAbsoluteStringWithBaseUrl:(BOOL)withBaseURL withQueryString:(BOOL)withQueryString {
  NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:withBaseURL];
  if (!withQueryString) components.query = nil;
  return [components URL].absoluteString;
}

#pragma mark - replaces
- (NSURLComponents *)wtNSURLComponents {
  NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
  return components;
}

- (NSURL *)wtReplaceScheme:(NSString *)scheme {
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  urlComponents.scheme = scheme;
  return urlComponents.URL;
}

- (NSURL *)wtReplaceHost:(NSString *)host {
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  urlComponents.host = host;
  return urlComponents.URL;
}

- (NSURL *)wtReplacePort:(NSNumber *)port {
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  urlComponents.port = port;
  return urlComponents.URL;
}

- (NSURL *)wtReplacePath:(NSString *)path {
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  urlComponents.path = path;
  return urlComponents.URL;
}

- (NSURL *)wtReplaceQuery:(NSDictionary *)query {
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  urlComponents.queryItems = [self _wtQueryItemsWithParameters:query];
  return urlComponents.URL;
}

- (NSURL *)wtReplaceFragment:(NSString *)fragment {
  NSURLComponents *urlComponents = [self wtNSURLComponents];
  urlComponents.fragment = fragment;
  return urlComponents.URL;
}

@end

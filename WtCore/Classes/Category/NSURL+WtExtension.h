//
// NSURL+WtExtension.h
// WtCore
//
// Created by wtfan on 2017/8/30.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>


@interface NSURL (WtExtension)

/// Gets all query string parameters from this URL.
- (NSDictionary<NSString *, NSArray<NSString *> *> *)wtQueryComponents;

/// Gets all query string parameters which cannot be duplicated from this URL.
- (NSDictionary<NSString *, NSString *> *)wtQueryComponentsWithNoDuplicate;

/// Gets the query string parameter from this URL with index.
/// @param name The query string.
/// @param index An index within the bounds of the array.
- (NSString *)wtQueryComponentNamed:(NSString *)name index:(NSInteger)index;

/// Gets query string parameters from this URL.
/// @param name The query string.
- (NSArray<NSString *> *)wtQueryComponentNamed:(NSString *)name;

/// Sorts and returns a newly created NSURL by all keys in the queries.
- (NSURL *)wtSortedByCompareQueryComponents;

/// Removes and returns a newly created NSURL with the dictionary queries.
/// @param queries An array of queries specifying the keys to remove, the keys are case sensitive.
- (NSURL *)wtRemoveQueries:(NSArray<NSString *> *)queries;

/// Removes and returns a newly created NSURL with the dictionary queries.
/// @param queries An array of queries specifying the keys to remove.
/// @param caseSensitive Wheter the key to remove is case sensitive.
- (NSURL *)wtRemoveQueries:(NSArray<NSString *> *)queries caseSensitive:(BOOL)caseSensitive;

/// Returns the absoluteString of this URL.
/// @param withBaseUrl If withBaseUrl is YES, the absoluteString is a full URL which has a baseUrl. If withBaseUrl is NO, the absoluteString is a relative URL that doesn't have the baseUrl.
/// @param withQueryString If withQueryString is YES, the absoluteString contains a query. If withQueryString is NO, the absoluteString doesn't have the query.
- (NSString *)wtAbsoluteStringWithBaseUrl:(BOOL)withBaseUrl withQueryString:(BOOL)withQueryString;

/// Initializes and returns a newly created NSURLComponents with the components of this URL.
- (NSURLComponents *)wtNSURLComponents;

/// Replaces and returns a newly created NSURL with scheme.
/// @param scheme The scheme.
- (NSURL *)wtReplaceScheme:(NSString *)scheme;

/// Replaces and returns a newly created NSURL with host.
/// @param host The host.
- (NSURL *)wtReplaceHost:(NSString *)host;

/// Replaces and returns a newly created NSURL with port.
/// @param port The port.
- (NSURL *)wtReplacePort:(NSNumber *)port;

/// Replaces and returns a newly created NSURL with path.
/// @param path The path.
- (NSURL *)wtReplacePath:(NSString *)path;

/// Replaces and returns a newly created NSURL with query.
/// @param query The query dictionary.
- (NSURL *)wtReplaceQuery:(NSDictionary *)query;

/// Replaces and returns a newly created NSURL with fragment.
/// @param fragment The fragment identifier.
- (NSURL *)wtReplaceFragment:(NSString *)fragment;

@end

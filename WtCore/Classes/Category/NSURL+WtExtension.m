//
//  NSURL+WtExtension.m
//  Pods
//
//  Created by wtfan on 2017/8/30.
//
//

#import "NSURL+WtExtension.h"

@implementation NSURL (WtExtension)
+ (NSDictionary *)wtParseQueryComponentsFromQueryString:(NSString *)queryStr includingDuplicateParamName:(BOOL)includingDuplicateParamName {
    NSMutableDictionary *results = [NSMutableDictionary new];
    if (queryStr && queryStr.length > 0) {
        NSArray *components = [queryStr componentsSeparatedByString:@"&"];
        for (NSString *component in components) {
            //检查kv的长度，有可能没value甚至没key
            /*NSArray *kv = [component componentsSeparatedByString:@"="];
             NSString *key = kv.count > 0 ? [kv objectAtIndex:0] : nil;
             NSString *value = kv.count > 1 ? [kv objectAtIndex:1] : nil;*/
            NSRange range = [component rangeOfString:@"="];
            NSString *key, *value;
            if (range.location == NSNotFound) {
                key = component;
                value = @"";
            }
            else {
                key = [component substringToIndex:range.location];
                value = [component substringFromIndex:range.location + 1];
            }
            if (value == nil) value = @"";
            //必须至少有个key，value默认为空字符串
            if (key && key.length && value) {
                id existedValue = [results objectForKey:key];
                if (existedValue) {
                    //如果key已经存在且需要考虑重名参数，则将key对应的值改成一个数组
                    if (includingDuplicateParamName) {
                        if ([existedValue isKindOfClass:[NSMutableArray class]]) {
                            [existedValue addObject:value];
                        }
                        else {
                            [results setObject:[NSMutableArray arrayWithObjects:existedValue, value, nil] forKey:key];
                        }
                    }
                }
                else {
                    [results setObject:value forKey:key];
                }
            }
        }
        
    }
    return results;
}

- (NSDictionary *)wtQueryComponents {
    return [[self class] wtParseQueryComponentsFromQueryString:self.query includingDuplicateParamName:YES];
}

- (NSString *)wtQueryComponentNamed:(NSString *)name index:(NSInteger)index {
    id result = [[self wtQueryComponents] objectForKey:name];
    if ([result isKindOfClass:[NSArray class]]) {
        if ([result count]) {
            return [result firstObject];
        }
        else return nil;
    }
    return result;
}

- (NSURL *)wtRemoveParams:(NSArray<NSString *> *)keys {
    NSMutableDictionary *queryComponents = [self wtQueryComponents].mutableCopy;
    NSMutableDictionary *lowercaseQueryKeyMapping = @{}.mutableCopy;
    
    NSMutableArray *lowercaseQueryKeys = @[].mutableCopy;
    for (NSString *key in queryComponents.allKeys) {
        NSString *lowKey = [key lowercaseString];
        [lowercaseQueryKeys addObject:lowKey];
        [lowercaseQueryKeyMapping setObject:key forKey:lowKey];
    }
    
    NSMutableArray *lowercaseInputKeys = @[].mutableCopy;
    for (NSString *key in keys) {
        [lowercaseInputKeys addObject:[key lowercaseString]];
    }
    
    NSMutableArray *params = @[].mutableCopy;
    
    NSMutableSet *paramKeys = [NSMutableSet setWithArray:lowercaseQueryKeys];
    [paramKeys minusSet:[NSSet setWithArray:lowercaseInputKeys]];
    for (NSString *key in paramKeys) {
        [params addObject:[NSString stringWithFormat:@"%@=%@", key, queryComponents[lowercaseQueryKeyMapping[key]]]];
    }
    
    NSString *query = [params componentsJoinedByString:@"&"];
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    components.path = self.path;
    components.query = query;
    return components.URL;
}

- (NSString *)withoutQueryString {
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    components.query = nil;
    return [components URL].absoluteString;
}

- (NSURL *)replaceRelativePath:(NSString *)relativePath {
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    components.path = relativePath;
    return [components URL];
}


@end

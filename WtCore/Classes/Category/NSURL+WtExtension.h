//
//  NSURL+WtExtension.h
//  WtCore
//
//  Created by wtfan on 2017/8/30.
//
//

#import <Foundation/Foundation.h>


@interface NSURL (WtExtension)
+ (NSDictionary *)wtParseQueryComponentsFromQueryString:(NSString *)queryStr includingDuplicateParamName:(BOOL)includingDuplicateParamName;
- (NSDictionary *)wtQueryComponents;
- (NSString *)wtQueryComponentNamed:(NSString *)name index:(NSInteger)index;
- (NSURL *)wtSortedByCompareQueryComponents;
- (NSURL *)wtRemoveParams:(NSArray<NSString *> *)keys;

- (NSString *)withoutQueryString;
- (NSURL *)replaceRelativePath:(NSString *)relativePath;

@end

//
//  NSUserDefaults+WtExtension.h
//  WtCore
//
//  Created by wtfan on 2018/8/19.
//

#import <Foundation/Foundation.h>


@interface NSUserDefaults (WtExtension)
+ (id)wtGetValueWithKey:(NSString *)key;
+ (BOOL)wtSaveValue:(id)value key:(NSString *)key;
@end

//
//  NSString+WtEncrypt.h
//  Pods
//
//  Created by wtfan on 2017/8/29.
//
//

#import <Foundation/Foundation.h>

NSString *wtStringFromMD5(NSString *str);

@interface NSString (WtEncrypt)
- (NSString *)wtStringFromMD5;
@end

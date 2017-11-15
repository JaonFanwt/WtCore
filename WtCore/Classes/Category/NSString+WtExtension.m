//
//  NSString+WtExtension.m
//  WtCore
//
//  Created by wtfan on 2017/9/12.
//
//

#import "NSString+WtExtension.h"

// Func
Class WTClassFromString(NSString *className) {
    Class c = NSClassFromString(className);
    if (c) return c;
    
    NSString *namespace = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    c = NSClassFromString([NSString stringWithFormat:@"%@.%@", namespace, className]);
    return c;
}

// Class
@implementation NSString (WtExtension)

@end

// HTML
@implementation NSString (WtHTML)
- (NSUInteger)wtIntegerValueFromHex {
    unsigned long result = 0;
    sscanf([self UTF8String], "%lx", &result);
    return (NSUInteger)result;
}
@end

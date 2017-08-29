//
//  NSString+WtEncrypt.m
//  Pods
//
//  Created by wtfan on 2017/8/29.
//
//

#import "NSString+WtEncrypt.h"

#import <CommonCrypto/CommonDigest.h>

NSString *wtStringFromMD5(NSString *str) {
    if (!str || str.length == 0 || ![str isKindOfClass:[NSString class]]) return nil;
    
    return [str wtStringFromMD5];
}

@implementation NSString (WtExtension)
- (NSString *)wtStringFromMD5 {
    if (self.length == 0) return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x", outputBuffer[i]];
    }
    
    return outputString;
}
@end

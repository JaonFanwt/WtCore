//
//  UIDevice+WtExtension.m
//  Pods
//
//  Created by wtfan on 2017/9/11.
//
//

#import "UIDevice+WtExtension.h"

@implementation UIDevice (WtExtension)
- (BOOL)wtEqualOrGreaterThan:(NSInteger)iOSVersion {
    BOOL b = [[[UIDevice currentDevice] systemVersion] compare:[NSString stringWithFormat:@"%zd.0", iOSVersion] options:NSNumericSearch] != NSOrderedAscending;
    return b;
}
@end

//
//  WtDebugBundle.m
//  Pods
//
//  Created by wtfan on 2017/5/23.
//
//

#import "WtDebugBundle.h"

@implementation WtDebugBundle
+ (NSBundle *)bundle {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"WtDebugTools" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}
@end

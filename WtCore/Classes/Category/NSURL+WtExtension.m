//
//  NSURL+WtExtension.m
//  Pods
//
//  Created by wtfan on 2017/8/30.
//
//

#import "NSURL+WtExtension.h"

@implementation NSURL (WtExtension)
- (NSString *)withoutQueryString {
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    components.query = nil;
    return [components URL].absoluteString;
}
@end

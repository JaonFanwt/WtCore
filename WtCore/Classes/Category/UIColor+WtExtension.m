//
//  UIColor+WtExtension.m
//  WtCore
//
//  Created by wtfan on 2017/9/12.
//
//

#import "UIColor+WtExtension.h"

@implementation UIColor (WtExtension)
+ (UIColor *)wtRandom {
    return [self wtRandomWithAlpha:1.0];
}

+ (UIColor *)wtRandomWithAlpha:(CGFloat)alpha {
    CGFloat red = (arc4random() % 256) / 256.0;
    CGFloat green = (arc4random() % 256) / 256.0;
    CGFloat blue = (arc4random() % 256) / 256.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end

//
//  UIColor+WtExtension.h
//  WtCore
//
//  Created by wtfan on 2017/9/12.
//
//

#import <Foundation/Foundation.h>

UIColor *wtRandomColor(CGFloat alpha);
UIColor *wtHTMLColor(NSString *name);


@interface UIColor (WtExtension)
+ (UIColor *)wtRandom;
+ (UIColor *)wtRandomWithAlpha:(CGFloat)alpha;
@end


@interface UIColor (WtHTML)
/**
 *  Support #RRGGBB; #RRGGBB alpha, e.g: #333333 0.5
 */
+ (UIColor *)wtColorWithHexString:(NSString *)hex;
+ (UIColor *)wtColorWithHTMLName:(NSString *)name;
@end

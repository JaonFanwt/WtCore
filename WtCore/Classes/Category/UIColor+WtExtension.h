//
// UIColor+WtExtension.h
// WtCore
//
// Created by wtfan on 2017/9/12.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>


/// Creates a random color object using the specified alpha.
/// @param alpha The alpha value of the color object.
UIColor *wtRandomColor(CGFloat alpha);

/// Creates a color object using the HTML color name.
/// @param name The HTML color name.
/// Support #RGB; #RRGGBB; #RRGGBB alpha;
/// e.g:
///     #333
///     #333333
///     #333333 0.5
///     rgba(0,0,0,1)
UIColor *wtHTMLColor(NSString *name);


@interface UIColor (WtExtension)

/// Creates a random color object.
+ (UIColor *)wtRandom;

/// Creates a random color object using the specified alpha.
/// @param alpha The alpha value of the color object.
+ (UIColor *)wtRandomWithAlpha:(CGFloat)alpha;

@end


@interface UIColor (WtHTML)

/// Creates a color object using the HTML color name.
/// @param hex The hex color name.
/// Support #RGB; #RRGGBB; #RRGGBB alpha;
/// e.g:
///     #333
///     #333333
///     #333333 0.5
+ (UIColor *)wtColorWithHexString:(NSString *)hex;

/// Creates a color object using the HTML color name.
/// @param name The HTML color name.
/// Support #RGB; #RRGGBB; #RRGGBB alpha;
/// e.g:
///     #333
///     #333333
///     #333333 0.5
///     rgba(0,0,0,1)
+ (UIColor *)wtColorWithHTMLName:(NSString *)name;

@end

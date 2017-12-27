//
//  UIFont+WtDebugTools.m
//  WtDebugTools
//
//  Created by fanwt on 2017/12/27.
//

#import "UIFont+WtDebugTools.h"

@implementation UIFont (WtDebugTools)
+ (void)wtPrintAll {
    NSLog(@"================= All Fonts ============================");
    for (NSString *familyName in [UIFont familyNames]) {
        NSLog(@" --------- FamilyName: %@ --------- ", familyName);
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for (NSString *fontName in fontNames) {
            NSLog(@"FontName: %@", fontName);
        }
    }
    NSLog(@"================= All Fonts ============================");
}
@end

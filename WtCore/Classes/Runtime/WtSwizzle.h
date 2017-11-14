//
//  WtSwizzle.h
//  WtCore
//
//  Created by wtfan on 2016/5/3.
//
//

#import <Foundation/Foundation.h>

void wt_swizzleClassStaticMethod(Class c, SEL originalSelector, SEL swizzledSelector);
void wt_swizzleSelector(Class c, SEL originalSelector, SEL swizzledSelector);

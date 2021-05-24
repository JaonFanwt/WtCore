//
//  WtSwizzle.h
//  WtCore
//
//  Created by wtfan on 2016/5/3.
//
//

#import <Foundation/Foundation.h>


/// Replace static method.
/// @param cls The class you want to modify.
/// @param originalSelector The original selector of the class.
/// @param swizzledSelector The replaced selector you want to modify.
void wt_swizzleClassStaticMethod(Class cls, SEL originalSelector, SEL swizzledSelector);

/// Replace method.
/// @param cls The class you want to modify.
/// @param originalSelector The original selector of the class.
/// @param swizzledSelector The replaced selector you want to modify.
void wt_swizzleSelector(Class cls, SEL originalSelector, SEL swizzledSelector);

/// Replace static method.
/// @param originalClass The original class you want to modify.
/// @param originalSelector The original selector of the class.
/// @param swizzledClass The replaced class you want to modify.
/// @param swizzledSelector The replaced selector you want to modify.
void wt_swizzleInnerClassStaicMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);

/// Replace method.
/// @param originalClass The original class you want to modify.
/// @param originalSelector The original selector of the class.
/// @param swizzledClass The replaced class you want to modify.
/// @param swizzledSelector The replaced selector you want to modify.
void wt_swizzleInnerSelector(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);

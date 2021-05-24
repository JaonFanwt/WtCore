//
//  WtSwizzle.m
//  WtCore
//
//  Created by wtfan on 2016/5/3.
//
//

#import "WtSwizzle.h"

#import <objc/runtime.h>

void wt_swizzleClassStaticMethod(Class c, SEL originalSelector, SEL swizzledSelector) {
  Method origMethod = class_getClassMethod(c, originalSelector);
  Method newMethod = class_getClassMethod(c, swizzledSelector);

  c = object_getClass((id)c);

  if (class_addMethod(c, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    class_replaceMethod(c, swizzledSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
  else
    method_exchangeImplementations(origMethod, newMethod);
}

void wt_swizzleSelector(Class c, SEL originalSelector, SEL swizzledSelector) {
  Method originalMethod = class_getInstanceMethod(c, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(c, swizzledSelector);
  if (class_addMethod(c, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
    class_replaceMethod(c, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

void wt_swizzleInnerClassStaicMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector) {
  Method originalMethod = class_getClassMethod(originalClass, originalSelector);
  Method swizzledMethod = class_getClassMethod(swizzledClass, swizzledSelector);
  class_addMethod(originalClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
  if (!class_addMethod(originalClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

void wt_swizzleInnerSelector(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector) {
  Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
  class_addMethod(originalClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
  if (!class_addMethod(originalClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

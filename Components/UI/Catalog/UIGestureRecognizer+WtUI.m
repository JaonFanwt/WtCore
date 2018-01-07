//
//  UIGestureRecognizer+WtUI.m
//  WtCore
//
//  Created by wtfan on 2018/1/7.
//

#import "UIGestureRecognizer+WtUI.h"

#import <objc/runtime.h>

#import "WtDispatch.h"

@implementation UIGestureRecognizer (WtUI)
#pragma mark private method
- (instancetype)initWithWtHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block {
    if (self = [self initWithTarget:self action:@selector(_wtHandlerGesture:)]) {
        self._wtHandlerBlock = block;
    }
    return self;
}

- (void)_wtHandlerGesture:(UIGestureRecognizer *)sender {
    CGPoint location = [self locationInView:self.view];
    wtDispatch_in_main(self._wtHandlerBlock, self, self.state, location);
}

- (void (^)(UIGestureRecognizer *, UIGestureRecognizerState, CGPoint))_wtHandlerBlock {
    return objc_getAssociatedObject(self, @selector(_wtHandlerBlock));
}

- (void)set_wtHandlerBlock:(void (^)(UIGestureRecognizer *, UIGestureRecognizerState, CGPoint))_wtHandlerBlock {
    objc_setAssociatedObject(self, @selector(_wtHandlerBlock), _wtHandlerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark public method
+ (instancetype)wtWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block {
    return [[[self class] alloc] initWithWtHandler:block];
}
@end
